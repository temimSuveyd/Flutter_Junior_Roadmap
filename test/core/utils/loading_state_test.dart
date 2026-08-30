import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/core/l10n/app_localizations.dart';
import 'package:juniorflutterroadmap/core/utils/loading_state.dart';

/// Minimal app wrapper so widgets can use the app's localizations and
/// design-system context extensions (colors, spacing, ...).
Widget buildTestApp(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

/// Widget test for the reusable loading state.
void main() {
  testWidgets('shows a spinner and the loading message', (tester) async {
    await tester.pumpWidget(
      buildTestApp(const LoadingState(message: 'Loading products...')),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading products...'), findsOneWidget);
  });
}
