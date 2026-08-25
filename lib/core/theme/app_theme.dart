import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_colors.dart';

class AppTheme {
  // 1. Light theme settings
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: LightColors.primary,
      scaffoldBackgroundColor: LightColors.background,
      cardColor: LightColors.surface,
      // You can also customize fonts and button shapes here.
    );
  }

  // 2. Dark theme settings
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: DarkColors.primary,
      scaffoldBackgroundColor: DarkColors.background,
      cardColor: DarkColors.surface,
    );
  }
}
