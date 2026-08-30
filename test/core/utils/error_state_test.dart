import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/core/l10n/app_localizations.dart';
import 'package:juniorflutterroadmap/core/utils/error_state.dart';

/// Minimal app wrapper so widgets can use the app's localizations and
/// design-system context extensions (colors, spacing, ...).
Widget buildTestApp(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

/// Widget test for the reusable error state (message + retry button).
void main() {
  testWidgets('shows the message and triggers onRetry when tapped', (
    tester,
  ) async {
    var retryTapped = false;

    await tester.pumpWidget(
      buildTestApp(
        ErrorState(
          message: 'Something went wrong',
          onRetry: () => retryTapped = true,
        ),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    expect(retryTapped, isTrue);
  });
}
