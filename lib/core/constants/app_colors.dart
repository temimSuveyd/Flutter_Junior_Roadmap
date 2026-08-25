import 'package:flutter/material.dart';

/// Centralized color palette for the app's visual identity.
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

