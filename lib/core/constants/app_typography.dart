import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Collects font styles used across the app.
final class AppTypography {
  AppTypography._();

  // ── Font Families ──
  static const String fontSans = 'Inter';
  static const String fontMono = 'JetBrains Mono';
  static const String fontArabic = 'Cairo';

  // ── Letter Spacing Helpers ──
  static double trackingTight(double fontSize) => fontSize * -0.03;
  static double trackingTighter(double fontSize) => fontSize * -0.04;
  static double trackingWide(double fontSize) => fontSize * 0.02;

  // ── Display (headings, large text) ──
  static TextStyle displayLarge = GoogleFonts.cairo(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    letterSpacing: 48 * -0.03,
    height: 1.1,
  );

  static TextStyle displayMedium = GoogleFonts.cairo(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 36 * -0.03,
    height: 1.15,
  );

  static TextStyle displaySmall = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 28 * -0.03,
    height: 1.2,
  );

  // ── Headlines ──
  static TextStyle headlineLarge = GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 24 * -0.03,
    height: 1.25,
  );

  static TextStyle headlineMedium = GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 20 * -0.03,
    height: 1.3,
  );

  static TextStyle headlineSmall = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 18 * -0.03,
    height: 1.35,
  );

  // ── Titles ──
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 16 * -0.02,
    height: 1.4,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 14 * -0.02,
    height: 1.4,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 12 * -0.02,
    height: 1.4,
  );

  // ── Body ──
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ── Labels ──
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ── Monospace (code, tabular data) ──
  static TextStyle monoMedium = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle monoSmall = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ── Data / Tabular Numbers ──
  static TextStyle tabularMedium = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFeatures: [const FontFeature.tabularFigures()],
    height: 1.5,
  );

  static TextStyle tabularSmall = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFeatures: [const FontFeature.tabularFigures()],
    height: 1.5,
  );

  // ── Button ──
  static TextStyle buttonLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle buttonSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ── Build a complete TextTheme for use in ThemeData ──
  /// Builds a complete text theme for use in ThemeData.
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  /// Text theme for tabular numbers and monospace data.
  static TextTheme get monoTextTheme => TextTheme(
    bodyMedium: tabularMedium,
    bodySmall: tabularSmall,
    labelMedium: monoMedium,
    labelSmall: monoSmall,
  );
}
