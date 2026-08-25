import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:juniorflutterroadmap/core/constants/app_constants.dart';

import '../../l10n/app_localizations.dart';

export 'package:juniorflutterroadmap/core/constants/app_constants.dart';

/// BuildContext theme helpers
extension AppThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;
}

/// Namespace extension for context helpers
extension AppContextX on BuildContext {
  ContextColors get colors => ContextColors.of(this);
  ContextSpacing get spacing => ContextSpacing.of(this);
  ContextRadius get radius => ContextRadius.of(this);
  ContextTypography get typography => ContextTypography.of(this);
  ContextResponsive get responsive => ContextResponsive.of(this);
  ContextL10n get l10n => ContextL10n.of(this);
  ContextAssets get assets => ContextAssets.of(this);

  // ── Direct color getters ──
  Color get primary => colors.primary;
  Color get background => colors.background;
  Color get surface => colors.surface;
  Color get textPrimary => colors.textPrimary;
  Color get textSecondary => colors.textSecondary;
  Color get border => colors.border;
  Color get success => colors.success;
  Color get warning => colors.warning;
  Color get error => colors.error;

  // ── Direct typography getters ──
  TextStyle get displayLarge => typography.displayLarge;
  TextStyle get displayMedium => typography.displayMedium;
  TextStyle get displaySmall => typography.displaySmall;
  TextStyle get headlineLarge => typography.headlineLarge;
  TextStyle get headlineMedium => typography.headlineMedium;
  TextStyle get headlineSmall => typography.headlineSmall;
  TextStyle get titleLarge => typography.titleLarge;
  TextStyle get titleMedium => typography.titleMedium;
  TextStyle get titleSmall => typography.titleSmall;
  TextStyle get bodyLarge => typography.bodyLarge;
  TextStyle get bodyMedium => typography.bodyMedium;
  TextStyle get bodySmall => typography.bodySmall;
  TextStyle get labelLarge => typography.labelLarge;
  TextStyle get labelMedium => typography.labelMedium;
  TextStyle get labelSmall => typography.labelSmall;
  TextStyle get buttonLarge => typography.buttonLarge;
  TextStyle get buttonSmall => typography.buttonSmall;
  TextStyle get monoMedium => typography.monoMedium;
  TextStyle get monoSmall => typography.monoSmall;
  TextStyle get tabularMedium => typography.tabularMedium;
  TextStyle get tabularSmall => typography.tabularSmall;

  // ── Direct spacing getters ──
  double get spaceXs => spacing.spaceXs;
  double get spaceSm => spacing.spaceSm;
  double get spaceMd => spacing.spaceMd;
  double get spaceLg => spacing.spaceLg;
  double get spaceXl => spacing.spaceXl;
  double get spaceXxl => spacing.spaceXxl;
  double get spaceXxxl => spacing.spaceXxxl;
  double get spaceXxxxl => spacing.spaceXxxxl;
  double get spaceXxxxxl => spacing.spaceXxxxxl;
  double get spaceHuge => spacing.spaceHuge;
  EdgeInsets get insetXs => spacing.insetXs;
  EdgeInsets get insetSm => spacing.insetSm;
  EdgeInsets get insetMd => spacing.insetMd;
  EdgeInsets get insetLg => spacing.insetLg;
  EdgeInsets get insetXl => spacing.insetXl;
  EdgeInsets get insetXxl => spacing.insetXxl;
  EdgeInsets get horizontalSm => spacing.horizontalSm;
  EdgeInsets get horizontalMd => spacing.horizontalMd;
  EdgeInsets get horizontalLg => spacing.horizontalLg;
  EdgeInsets get horizontalXl => spacing.horizontalXl;
  EdgeInsets get verticalSm => spacing.verticalSm;
  EdgeInsets get verticalMd => spacing.verticalMd;
  EdgeInsets get verticalLg => spacing.verticalLg;
  EdgeInsets get verticalXl => spacing.verticalXl;
  SizedBox get hGapXs => spacing.hGapXs;
  SizedBox get hGapSm => spacing.hGapSm;
  SizedBox get hGapMd => spacing.hGapMd;
  SizedBox get hGapLg => spacing.hGapLg;
  SizedBox get hGapXl => spacing.hGapXl;
  SizedBox get hGapXxl => spacing.hGapXxl;
  SizedBox get vGapXs => spacing.vGapXs;
  SizedBox get vGapSm => spacing.vGapSm;
  SizedBox get vGapMd => spacing.vGapMd;
  SizedBox get vGapLg => spacing.vGapLg;
  SizedBox get vGapXl => spacing.vGapXl;
  SizedBox get vGapXxl => spacing.vGapXxl;

  // ── Direct radius getters ──
  BorderRadius get radiusXs => radius.radiusXs;
  BorderRadius get radiusSm => radius.radiusSm;
  BorderRadius get radiusMd => radius.radiusMd;
  BorderRadius get radiusLg => radius.radiusLg;
  BorderRadius get radiusXl => radius.radiusXl;
  BorderRadius get radiusXxl => radius.radiusXxl;
  BorderRadius get radiusFull => radius.radiusFull;

  // ── Direct responsive getters ──
  double get screenWidth => responsive.screenWidth;
  double get screenHeight => responsive.screenHeight;
  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;

  // ── Direct l10n getters ──
  AppLocalizations get t => l10n.t;
  bool get isRtl => l10n.isRtl;
  String get currentLanguage => l10n.currentLanguage;

  // ── Direct assets getters ──
  String get emptyImageIcon => assets.emptyImageIcon;
}

/// Colors helper with lazy caching
class ContextColors {

  factory ContextColors.of(BuildContext context) =>
      _instances.putIfAbsent(context, () => ContextColors._(context));
  const ContextColors._(this.context);
  final BuildContext context;

  static final _instances = <BuildContext, ContextColors>{};

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

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

/// Spacing helper with lazy caching
class ContextSpacing {

  factory ContextSpacing.of(BuildContext context) =>
      _instances.putIfAbsent(context, () => ContextSpacing._(context));
  const ContextSpacing._(this.context);
  final BuildContext context;

  static final _instances = <BuildContext, ContextSpacing>{};

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

  SizedBox get hGapXs => const SizedBox(width: AppSpacing.xs);
  SizedBox get hGapSm => const SizedBox(width: AppSpacing.sm);
  SizedBox get hGapMd => const SizedBox(width: AppSpacing.md);
  SizedBox get hGapLg => const SizedBox(width: AppSpacing.lg);
  SizedBox get hGapXl => const SizedBox(width: AppSpacing.xl);
  SizedBox get hGapXxl => const SizedBox(width: AppSpacing.xxl);

  SizedBox get vGapXs => const SizedBox(height: AppSpacing.xs);
  SizedBox get vGapSm => const SizedBox(height: AppSpacing.sm);
  SizedBox get vGapMd => const SizedBox(height: AppSpacing.md);
  SizedBox get vGapLg => const SizedBox(height: AppSpacing.lg);
  SizedBox get vGapXl => const SizedBox(height: AppSpacing.xl);
  SizedBox get vGapXxl => const SizedBox(height: AppSpacing.xxl);
}

/// Radius helper with lazy caching
class ContextRadius {

  factory ContextRadius.of(BuildContext context) =>
      _instances.putIfAbsent(context, () => ContextRadius._(context));
  const ContextRadius._(this.context);
  final BuildContext context;

  static final _instances = <BuildContext, ContextRadius>{};

  BorderRadius get radiusXs => BorderRadius.circular(AppSpacing.radiusXs);
  BorderRadius get radiusSm => BorderRadius.circular(AppSpacing.radiusSm);
  BorderRadius get radiusMd => BorderRadius.circular(AppSpacing.radiusMd);
  BorderRadius get radiusLg => BorderRadius.circular(AppSpacing.radiusLg);
  BorderRadius get radiusXl => BorderRadius.circular(AppSpacing.radiusXl);
  BorderRadius get radiusXxl => BorderRadius.circular(AppSpacing.radiusXxl);
  BorderRadius get radiusFull => BorderRadius.circular(AppSpacing.radiusFull);

  // Short aliases used across the project (e.g. `context.radius.lg`).
  BorderRadius get xs => radiusXs;
  BorderRadius get sm => radiusSm;
  BorderRadius get md => radiusMd;
  BorderRadius get lg => radiusLg;
  BorderRadius get xl => radiusXl;
  BorderRadius get xxl => radiusXxl;
  BorderRadius get full => radiusFull;
}

/// Typography helper with lazy caching
class ContextTypography {

  factory ContextTypography.of(BuildContext context) =>
      _instances.putIfAbsent(context, () => ContextTypography._(context));
  const ContextTypography._(this.context);
  final BuildContext context;

  static final _instances = <BuildContext, ContextTypography>{};

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

/// Responsive helper with lazy caching
class ContextResponsive {

  factory ContextResponsive.of(BuildContext context) =>
      _instances.putIfAbsent(context, () => ContextResponsive._(context));
  const ContextResponsive._(this.context);
  final BuildContext context;

  static final _instances = <BuildContext, ContextResponsive>{};

  static const double _mobileMax = 600.0;
  static const double _tabletMax = 1024.0;

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  bool get isMobile => screenWidth < _mobileMax;
  bool get isTablet => screenWidth >= _mobileMax && screenWidth < _tabletMax;
  bool get isDesktop => screenWidth >= _tabletMax;
}

/// L10n helper with lazy caching
class ContextL10n {

  factory ContextL10n.of(BuildContext context) =>
      _instances.putIfAbsent(context, () => ContextL10n._(context));
  const ContextL10n._(this.context);
  final BuildContext context;

  static final _instances = <BuildContext, ContextL10n>{};

  AppLocalizations get t => AppLocalizations.of(context)!;
  String get currentLanguage => Localizations.localeOf(context).languageCode;
  bool get isRtl => currentLanguage == 'ar';

  String formatDayMonth(DateTime date) {
    return DateFormat.MMMMd(currentLanguage).format(date);
  }

  String formatFullDate(DateTime date) {
    return DateFormat.yMMMMd(currentLanguage).format(date);
  }
}

/// Assets helper with lazy caching
class ContextAssets {

  factory ContextAssets.of(BuildContext context) =>
      _instances.putIfAbsent(context, () => ContextAssets._(context));
  const ContextAssets._(this.context);
  final BuildContext context;

  static final _instances = <BuildContext, ContextAssets>{};

  String get emptyImageIcon => AppImages.emptyImageIcon;
}
