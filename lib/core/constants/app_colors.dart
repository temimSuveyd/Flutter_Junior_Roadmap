import 'package:flutter/material.dart';

/// لوحة الألوان الموحدة للهوية البصرية للتطبيق.
final class AppColors {
  AppColors._();

  // ── Shadows ──
  static const Color shadowBorder = Color(0x14000000);
  static const Color shadowAmbient = Color(0x0A000000);
  static const Color shadowInner = Color(0xFFFAFAFA);
  static const Color shadowElevated = Color(0x1A000000);
}

// ──────────────────────────────────────────────
// LIGHT MODE
// ──────────────────────────────────────────────
final class LightColors {
  LightColors._();

  static const Color primary = Color(0xFFE53935);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF171717);
  static const Color textSecondary = Color(0xFF737373);
  static const Color border = Color(0xFFE0E0E0);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}

// ──────────────────────────────────────────────
// DARK MODE
// ──────────────────────────────────────────────
final class DarkColors {
  DarkColors._();

  static const Color primary = Color(0xFFEF5350);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color border = Color(0xFF2A2A2A);
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);
}

/// ملحق لتسهيل استخدام الألوان حسب الوضع (فاتح/داكن).
extension AppColorsX on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get primary => _isDark ? DarkColors.primary : LightColors.primary;
  Color get background =>
      _isDark ? DarkColors.background : LightColors.background;
  Color get surface => _isDark ? DarkColors.surface : LightColors.surface;
  Color get textPrimary =>
      _isDark ? DarkColors.textPrimary : LightColors.textPrimary;
  Color get textSecondary =>
      _isDark ? DarkColors.textSecondary : LightColors.textSecondary;
  Color get border => _isDark ? DarkColors.border : LightColors.border;
  Color get success => _isDark ? DarkColors.success : LightColors.success;
  Color get warning => _isDark ? DarkColors.warning : LightColors.warning;
  Color get error => _isDark ? DarkColors.error : LightColors.error;
}