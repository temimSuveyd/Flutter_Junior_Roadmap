import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_colors.dart';

class AppTheme {
  // 1. إعدادات الثيم المضيء
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: LightColors.primary,
      scaffoldBackgroundColor: LightColors.background,
      cardColor: LightColors.surface,
      // يمكنك تخصيص الخطوط وأشكال الأزرار هنا أيضاً
    );
  }

  // 2. إعدادات الثيم المظلم
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: DarkColors.primary,
      scaffoldBackgroundColor: DarkColors.background,
      cardColor: DarkColors.surface,
    );
  }
}
