import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:integration_test/integration_test.dart';
import 'package:juniorflutterroadmap/core/utils/app_network_image.dart';
import 'package:juniorflutterroadmap/core/utils/app_primary_button.dart';
import 'package:juniorflutterroadmap/core/utils/app_value.dart';
import 'package:juniorflutterroadmap/core/utils/empty_state.dart';
import 'package:juniorflutterroadmap/features/products/presentation/pages/search_page.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/banner_slider.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/category_list.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/home_search_bar.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/product_card.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/product_details_gallery.dart';
import 'package:juniorflutterroadmap/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:juniorflutterroadmap/main.dart' as app;

/// End-to-end flow required by the roadmap (Day 24 integration test).
///
/// Flow (locale-independent — every finder uses a TYPE or an ICON, never a
/// localized text label, so it works in English, Arabic/RTL, or any language):
///
///   1. LOGIN            (pre-filled test account; just tap the button)
///   2. HOME             assert ProductCard grid + BannerSlider + CategoryList
///   3. DETAILS (home)   tap a ProductCard, assert AppNetworkImage, go back
///   4. SEARCH           open search (icon), type "blue", assert + open result (retry once on empty)
///   5. DETAILS (search) assert AppNetworkImage, go back twice -> Home
///   6. PROFILE          open profile, change-photo sheet, remove photo (if any)
///   7. ADDRESS          go Home, open location dialog, Save, assert city on Home
///
/// It is time-independent: it waits until the next expected widget actually
/// appears (`waitFor*` helpers) instead of using fixed sleeps.
///
/// Requirements:
///   * Run on a real device/emulator (not `flutter test` on the host).
///   * Internet access to the fake API (api.escuelajs.co).
///   * Firebase already configured for the app.
///   * The sign-in form is pre-filled with a test account, so we just tap it.
///   * We intentionally do NOT open the native gallery/camera picker.

/// Pumps for a short, fixed duration.
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
}) => waitForAny(tester, [finder], timeoutSeconds: timeoutSeconds);

/// Taps the first matching widget. Resolves the element explicitly (via
/// `evaluate().first` + `find.byWidget`) to avoid the `finder.first` quirk on
/// descendant finders. `warnIfMissed: false` keeps the log clean.
Future<void> tapFirst(WidgetTester tester, Finder finder) async {
  final elements = finder.evaluate().toList();
  if (elements.isEmpty) {
    throw Exception('tapFirst: no widgets found for $finder');
  }
  await tester.tap(find.byWidget(elements.first.widget), warnIfMissed: false);
}

/// Finds the first widget of [type] that is a descendant of [ancestor].
Finder descendantOfType(Type ancestor, Type type) =>
    find.descendant(of: find.byType(ancestor), matching: find.byType(type));

/// Taps the first ProductCard whose product has a non-empty image list.
/// Returns `true` when such a card was tapped (so an `AppNetworkImage` is
/// expected on the details page); otherwise taps the first available card and
/// returns `false`. This makes the image assertion safe even when some products
/// have no images (the gallery then shows a placeholder instead of crashing).
Future<bool> tapProductWithImage(WidgetTester tester, Finder cards) async {
  final elements = cards.evaluate().toList();
  if (elements.isEmpty) {
    throw Exception('tapProductWithImage: no ProductCard found');
  }
  for (final el in elements) {
    final product = (el.widget as ProductCard).product;
    final images = product.image;
    if (images.isNotEmpty) {
      await tester.tap(find.byWidget(el.widget), warnIfMissed: false);
      return true;
    }
  }
  await tester.tap(find.byWidget(elements.first.widget), warnIfMissed: false);
  return false;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Full user flow: login → home → details → search → details → profile → address',
    (tester) async {
      // ---------------------------------------------------------------
      // 1. LOGIN
      // ---------------------------------------------------------------
      app.main();
      await waitForAny(tester, [
        find.byType(AppPrimaryButton), // sign-in page
        find.byType(ProductCard), // already authenticated
      ]);

      if (find.byType(ProductCard).evaluate().isEmpty) {
        await tapFirst(tester, find.byType(AppPrimaryButton));
        await waitFor(tester, find.byType(ProductCard)); // home after login
      }

      // ---------------------------------------------------------------
      // 2. HOME — assert the core sections exist.
      // ---------------------------------------------------------------
      expect(find.byType(ProductCard), findsWidgets); // product grid
      expect(find.byType(BannerSlider), findsWidgets); // banner slider
      expect(find.byType(CategoryList), findsWidgets); // category list

      // ---------------------------------------------------------------
      // 3. DETAILS (from home): open a product and check its image.
      // The details route is top-level, so Home is unmounted while it is open;
      // we verify the page via ProductDetailsGallery (always present once loaded)
      // and only assert AppNetworkImage when the tapped product actually has images.
      // ---------------------------------------------------------------
      final homeHasImage = await tapProductWithImage(
        tester,
        find.byType(ProductCard),
      );
      await waitFor(
        tester,
        find.byIcon(Icons.adaptive.arrow_back),
      ); // details appBar
      await waitFor(
        tester,
        find.byType(ProductDetailsGallery),
      ); // details loaded
      expect(find.byType(ProductDetailsGallery), findsWidgets);
      if (homeHasImage) {
        expect(
          descendantOfType(ProductDetailsGallery, AppNetworkImage),
          findsWidgets,
        );
      }
      await tapFirst(
        tester,
        find.byIcon(Icons.adaptive.arrow_back),
      ); // back to Home
      await waitFor(tester, find.byType(ProductCard));

      // ---------------------------------------------------------------
      // 4. SEARCH: open search (icon), type "blue", open a result.
      // If the results are empty (EmptyState), search "blue" again once.
      // ---------------------------------------------------------------
      await tapFirst(
        tester,
        find.descendant(
          of: find.byType(HomeSearchBar),
          matching: find.byIcon(IconsaxPlusLinear.search_normal_1),
        ),
      );
      await waitFor(tester, find.byType(SearchPage));
      final searchField = descendantOfType(SearchPage, TextField);

      Future<void> searchBlue() async {
        await tester.enterText(searchField, '');
        await tester.enterText(searchField, 'blue');
      }

      await searchBlue();
      // Wait for either results or the empty state.
      await waitForAny(tester, [
        descendantOfType(SearchPage, ProductCard),
        find.byType(EmptyState),
      ]);
      // Retry once when the page shows the empty state.
      if (find.byType(EmptyState).evaluate().isNotEmpty) {
        await searchBlue();
        await waitFor(
          tester,
          descendantOfType(SearchPage, ProductCard),
        ); // results loaded (retry)
      }

      final searchHasImage = await tapProductWithImage(
        tester,
        descendantOfType(SearchPage, ProductCard),
      );
      await waitFor(tester, find.byIcon(Icons.adaptive.arrow_back)); // details
      await waitFor(
        tester,
        find.byType(ProductDetailsGallery),
      ); // details loaded
      expect(find.byType(ProductDetailsGallery), findsWidgets);
      if (searchHasImage) {
        expect(
          descendantOfType(ProductDetailsGallery, AppNetworkImage),
          findsWidgets,
        );
      }

      // ---------------------------------------------------------------
      // 5. Back twice: details -> SearchPage -> Home.
      // ---------------------------------------------------------------
      await tapFirst(
        tester,
        find.byIcon(Icons.adaptive.arrow_back),
      ); // -> SearchPage
      await waitFor(tester, find.byIcon(Icons.adaptive.arrow_back));
      await tapFirst(tester, find.byIcon(Icons.adaptive.arrow_back)); // -> Home
      await waitFor(tester, find.byType(ProductCard));

      // ---------------------------------------------------------------
      // 6. PROFILE: open profile, change-photo sheet, remove photo (if any).
      // ---------------------------------------------------------------
      await tapFirst(tester, find.byIcon(IconsaxPlusLinear.profile));
      await waitFor(tester, find.byType(ProfileAvatar));

      // Open the "change photo" sheet. On this page the change-photo action is
      // triggered by the profile avatar (ProfileAvatar), which opens the
      // photo-options sheet.
      await tapFirst(tester, find.byType(ProfileAvatar));
      await waitFor(
        tester,
        find.byIcon(Icons.photo_library_outlined),
      ); // sheet open (gallery icon is always present in the sheet)

      final removeOption = find.byIcon(Icons.delete_outline);
      if (removeOption.evaluate().isNotEmpty) {
        // There is an avatar -> the "remove photo" action is available.
        await tapFirst(tester, removeOption);
        // A confirmation AlertDialog appears (actions: Cancel, Remove).
        await waitFor(tester, find.byType(AlertDialog));
        final confirmButtons = find
            .descendant(
              of: find.byType(AlertDialog),
              matching: find.byType(TextButton),
            )
            .evaluate()
            .toList();
        await tester.tap(
          find.byWidget(
            confirmButtons.last.widget,
          ), // "Remove" is the last button
          warnIfMissed: false,
        );
        await wait(tester, 1500); // profile reloads without the avatar
        // Definite success check: the avatar no longer shows a network image.
        final stillHasAvatarImage = find
            .descendant(
              of: find.byType(ProfileAvatar),
              matching: find.byType(AppNetworkImage),
            )
            .evaluate()
            .isNotEmpty;
        expect(stillHasAvatarImage, isFalse);
      } else {
        // No avatar on this account -> nothing to remove; just close the sheet.
        await tester.tapAt(const Offset(20, 20)); // tap the modal barrier
        await wait(tester, 500);
      }

      // ---------------------------------------------------------------
      // 7. ADDRESS: back to Home, open location dialog, Save, assert city.
      // ---------------------------------------------------------------
      await tapFirst(tester, find.byIcon(IconsaxPlusLinear.home_2)); // -> Home
      await waitFor(tester, find.byType(ProductCard));

      await tapFirst(
        tester,
        find.byIcon(IconsaxPlusBroken.location),
      ); // open dialog
      await waitFor(tester, find.byType(AlertDialog));
      // Wait until the address is resolved and the Save button is shown.
      final saveFinder = descendantOfType(AlertDialog, AppPrimaryButton);
      await waitFor(tester, saveFinder);
      // Capture the detected city from the dialog's first AppValue (city field).
      String? city;
      final appValues = tester.widgetList<AppValue>(find.byType(AppValue));
      if (appValues.isNotEmpty) city = appValues.first.value;
      // Tap "Save address".
      await tapFirst(tester, saveFinder);
      await wait(tester); // dialog closes, Home header updates
      // Definite success check: the saved city now appears on the Home header.
      if (city != null && city.trim().isNotEmpty) {
        expect(find.text(city), findsWidgets);
      }
    },
  );
}
