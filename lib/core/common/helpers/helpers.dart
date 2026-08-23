import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:juniorflutterroadmap/core/constants/app_constants.dart';

import '../../l10n/app_localizations.dart';

export 'package:juniorflutterroadmap/core/constants/app_constants.dart';

/// ملحق لتسهيل الوصول إلى الثيم والمسافات والأنماط النصية من أي واجهة.
extension AppThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;
}

/// ملحق يوفر أنماط النصوص الموحدة عبر التطبيق.
extension AppTypographyX on BuildContext {
  TextStyle get displayLarge => AppTypography.displayLarge;
  TextStyle get displayMedium => AppTypography.displayMedium;
  TextStyle get displaySmall => AppTypography.displaySmall;

  TextStyle get headlineLarge => AppTypography.headlineLarge;
  TextStyle get headlineMedium => AppTypography.headlineMedium;
  TextStyle get headlineSmall => AppTypography.headlineSmall;

  TextStyle get titleLarge => AppTypography.titleLarge;
  TextStyle get titleMedium => AppTypography.titleMedium;
  TextStyle get titleSmall => AppTypography.titleSmall;

  TextStyle get bodyLarge => AppTypography.bodyLarge;
  TextStyle get bodyMedium => AppTypography.bodyMedium;
  TextStyle get bodySmall => AppTypography.bodySmall;

  TextStyle get labelLarge => AppTypography.labelLarge;
  TextStyle get labelMedium => AppTypography.labelMedium;
  TextStyle get labelSmall => AppTypography.labelSmall;

  TextStyle get buttonLarge => AppTypography.buttonLarge;
  TextStyle get buttonSmall => AppTypography.buttonSmall;

  TextStyle get monoMedium => AppTypography.monoMedium;
  TextStyle get monoSmall => AppTypography.monoSmall;

  TextStyle get tabularMedium => AppTypography.tabularMedium;
  TextStyle get tabularSmall => AppTypography.tabularSmall;
}

/// ملحق يوفر قيم المسافات والحشوات والفواصل الموحدة.
extension AppSpacingX on BuildContext {
  double get spaceXs => AppSpacing.xs;
  double get spaceSm => AppSpacing.sm;
  double get spaceMd => AppSpacing.md;
  double get spaceLg => AppSpacing.lg;
  double get spaceXl => AppSpacing.xl;
  double get spaceXxl => AppSpacing.xxl;
  double get spaceXxxl => AppSpacing.xxxl;
  double get spaceXxxxl => AppSpacing.xxxxl;
  double get spaceXxxxxl => AppSpacing.xxxxxl;
  double get spaceHuge => AppSpacing.huge;

  EdgeInsets get insetXs => AppSpacing.insetXs;
  EdgeInsets get insetSm => AppSpacing.insetSm;
  EdgeInsets get insetMd => AppSpacing.insetMd;
  EdgeInsets get insetLg => AppSpacing.insetLg;
  EdgeInsets get insetXl => AppSpacing.insetXl;
  EdgeInsets get insetXxl => AppSpacing.insetXxl;

  EdgeInsets get horizontalSm => AppSpacing.horizontalSm;
  EdgeInsets get horizontalMd => AppSpacing.horizontalMd;
  EdgeInsets get horizontalLg => AppSpacing.horizontalLg;
  EdgeInsets get horizontalXl => AppSpacing.horizontalXl;

  EdgeInsets get verticalSm => AppSpacing.verticalSm;
  EdgeInsets get verticalMd => AppSpacing.verticalMd;
  EdgeInsets get verticalLg => AppSpacing.verticalLg;
  EdgeInsets get verticalXl => AppSpacing.verticalXl;

  SizedBox get hGapXs => SizedBox(width: AppSpacing.xs);
  SizedBox get hGapSm => SizedBox(width: AppSpacing.sm);
  SizedBox get hGapMd => SizedBox(width: AppSpacing.md);
  SizedBox get hGapLg => SizedBox(width: AppSpacing.lg);
  SizedBox get hGapXl => SizedBox(width: AppSpacing.xl);
  SizedBox get hGapXxl => SizedBox(width: AppSpacing.xxl);

  SizedBox get vGapXs => SizedBox(height: AppSpacing.xs);
  SizedBox get vGapSm => SizedBox(height: AppSpacing.sm);
  SizedBox get vGapMd => SizedBox(height: AppSpacing.md);
  SizedBox get vGapLg => SizedBox(height: AppSpacing.lg);
  SizedBox get vGapXl => SizedBox(height: AppSpacing.xl);
  SizedBox get vGapXxl => SizedBox(height: AppSpacing.xxl);
}

/// ملحق يوفر أنصاف أقطار الزوايا الموحدة.
extension AppRadiusX on BuildContext {
  BorderRadius get radiusXs => BorderRadius.circular(AppSpacing.radiusXs);
  BorderRadius get radiusSm => BorderRadius.circular(AppSpacing.radiusSm);
  BorderRadius get radiusMd => BorderRadius.circular(AppSpacing.radiusMd);
  BorderRadius get radiusLg => BorderRadius.circular(AppSpacing.radiusLg);
  BorderRadius get radiusXl => BorderRadius.circular(AppSpacing.radiusXl);
  BorderRadius get radiusXxl => BorderRadius.circular(AppSpacing.radiusXxl);
  BorderRadius get radiusFull => BorderRadius.circular(AppSpacing.radiusFull);
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



extension LocalizedBuildContext on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this)!;
  String get currentLanguage => Localizations.localeOf(this).languageCode;
  bool get isRtl => currentLanguage == 'ar';
}

extension DateFormatter on BuildContext {
  String formatDayMonth(DateTime date) {
    return DateFormat.MMMMd(currentLanguage).format(date);
  }

  String formatFullDate(DateTime date) {
    return DateFormat.yMMMMd(currentLanguage).format(date);
  }
}

