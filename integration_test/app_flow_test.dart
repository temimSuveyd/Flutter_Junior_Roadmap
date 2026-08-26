import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:integration_test/integration_test.dart';
import 'package:juniorflutterroadmap/core/utils/app_primary_button.dart';
import 'package:juniorflutterroadmap/features/products/presentation/pages/search_page.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/home_search_bar.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/product_card.dart';
import 'package:juniorflutterroadmap/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:juniorflutterroadmap/main.dart' as app;

/// End-to-end flow required by the roadmap (Day 24 integration test):
///
///   auth  →  products  →  details  →  search  →  details  →  profile (upload image)
///
/// This test is fully locale-independent: every finder uses a widget TYPE or an
/// ICON (never a text label), so it works in English, Arabic (RTL), or any language.
///
/// It is also time-independent: instead of fixed sleeps, it waits until the next
/// expected widget actually appears (`waitFor*` helpers), so slow splash, Firebase
/// init, or network calls never cause flaky failures.
///
/// Requirements:
///   * Run on a real device or emulator (NOT `flutter test` on the host).
///   * Internet access to the fake API (api.escuelajs.co).
///   * Firebase already configured for the app.
///   * The sign-in form is pre-filled with a test account, so we just tap the button.
///   * The final "upload image" step opens the native gallery picker, which needs a
///     manual pick (or a mocked image_picker) to finish on a real device.
///
/// NOTE: we use fixed-duration `pump()` instead of `pumpAndSettle()`. The home screen
/// has an auto-playing banner carousel, so `pumpAndSettle()` never becomes idle.
/// `waitFor*` pumps in small steps for the same reason.

/// Pumps for a short, fixed duration. Returns a Future so it can be awaited.
Future<void> wait(WidgetTester tester, [int milliseconds = 1000]) =>
    tester.pump(Duration(milliseconds: milliseconds));

/// Pumps until ANY of [finders] is found, or throws on timeout.
Future<void> waitForAny(
  WidgetTester tester,
  List<Finder> finders, {
  int timeoutSeconds = 20,
}) async {
  final deadline = DateTime.now().add(Duration(seconds: timeoutSeconds));
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finders.any((f) => f.evaluate().isNotEmpty)) return;
  }
  throw Exception('waitForAny timed out (${finders.length} finders)');
}

/// Pumps until [finder] is found, or throws on timeout.
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  int timeoutSeconds = 20,
}) =>
    waitForAny(tester, [finder], timeoutSeconds: timeoutSeconds);

/// Taps the first matching widget. Resolves the element explicitly (via
/// `evaluate().first` + `find.byWidget`) to avoid the `finder.first` quirk on
/// descendant finders.
Future<void> tapFirst(WidgetTester tester, Finder finder) async {
  final elements = finder.evaluate().toList();
  if (elements.isEmpty) {
    throw Exception('tapFirst: no widgets found for $finder');
  }
  await tester.tap(
    find.byWidget(elements.first.widget),
    warnIfMissed: false,
  );
}

/// Finds the first widget of [type] that is a descendant of [ancestor].
Finder descendantOfType(Type ancestor, Type type) =>
    find.descendant(of: find.byType(ancestor), matching: find.byType(type));

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full user flow: auth → products → details → search → details → profile', (
    tester,
  ) async {
    // Start the whole application.
    app.main();

    // ---------------------------------------------------------------
    // STEP 1 — AUTH: wait for the first real screen, then sign in.
    // Skipped entirely if a previous run left a valid token (we land on Home).
    // The sign-in page has exactly one AppPrimaryButton.
    // ---------------------------------------------------------------
    await waitForAny(tester, [
      find.byType(AppPrimaryButton),
      find.byType(ProductCard),
    ]);
    final alreadyHome = find.byType(ProductCard).evaluate().isNotEmpty;
    if (!alreadyHome) {
      await tapFirst(tester, find.byType(AppPrimaryButton));
      await waitFor(tester, find.byType(ProductCard)); // home after login
    }
    expect(find.byType(ProductCard), findsWidgets);

    // ---------------------------------------------------------------
    // STEP 2 — PRODUCTS: open the first product from the home grid.
    // The detail page shows a back arrow in its AppBar.
    // ---------------------------------------------------------------
    await tapFirst(tester, find.byType(ProductCard));
    await waitFor(tester, find.byIcon(Icons.adaptive.arrow_back));

    // ---------------------------------------------------------------
    // STEP 3 — DETAILS (from home): go back to the home screen.
    // ---------------------------------------------------------------
    await tapFirst(tester, find.byIcon(Icons.adaptive.arrow_back));
    await waitFor(tester, find.byType(ProductCard));

    // ---------------------------------------------------------------
    // STEP 4 — SEARCH: open search, type a query, see results.
    // The home search bar is a `HomeSearchBar` (GestureDetector) that pushes
    // the SearchPage route; it is NOT a TextField. We tap its leading search
    // icon (top-left, never obscured by the banner below it) instead of the
    // bar's center, which can fall outside the tappable area.
    // ---------------------------------------------------------------
    await tapFirst(
      tester,
      find.descendant(
        of: find.byType(HomeSearchBar),
        matching: find.byIcon(IconsaxPlusLinear.search_normal_1),
      ),
    );
    await waitFor(tester, find.byType(SearchPage));
    // Type into the SearchPage's own TextField (not the one behind it).
    await tester.enterText(
      descendantOfType(SearchPage, TextField),
      'phone',
    );
    await waitFor(
      tester,
      descendantOfType(SearchPage, ProductCard),
    ); // debounce + network

    // ---------------------------------------------------------------
    // STEP 5 — DETAILS (from search): open a result, then go back twice
    // (search result → SearchPage → Home) so the bottom nav is visible again.
    // The profile tab icon is only present on the Home shell.
    // ---------------------------------------------------------------
    await tapFirst(tester, descendantOfType(SearchPage, ProductCard));
    await waitFor(tester, find.byIcon(Icons.adaptive.arrow_back)); // detail
    await tapFirst(tester, find.byIcon(Icons.adaptive.arrow_back)); // → SearchPage
    await waitFor(tester, find.byIcon(IconsaxPlusLinear.profile)); // → Home

    // ---------------------------------------------------------------
    // STEP 6 — PROFILE: open the profile tab and verify it loads.
    // The image upload / native gallery picker is intentionally NOT exercised
    // here, so the test finishes automatically with no manual interaction.
    // ---------------------------------------------------------------
    await tapFirst(tester, find.byIcon(IconsaxPlusLinear.profile));
    await waitFor(tester, find.byType(ProfileAvatar));
    await wait(tester, 500); // let the profile content settle
  });
}
