export 'app_colors.dart';
export 'app_spacing.dart';
export 'app_typography.dart';

/// General constants for layout, pagination and animation durations.
final class AppConstants {
  AppConstants._();

  // ── Layout ──
  static const double maxContentWidth = 1200;
  static const double maxFormWidth = 480;
  static const double bottomNavBarHeight = 64;
  static const double appBarHeight = 56;

  // ── Pagination ──
  static const int pageSize = 20;
  static const int pageSizeSmall = 10;

  // ── Stock ──
  static const int lowStockThreshold = 10;

  // ── Animation Durations ──
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration mediumDuration = Duration(milliseconds: 250);
  static const Duration slowDuration = Duration(milliseconds: 400);
  static const Duration showDelay = Duration(milliseconds: 200);
}

/// Images used on specific screens like the auth screen.
final class AppImages {
  AppImages._();

  static const String authBackgroundImage =
      'assets/images/auth_background_image.png';
  static const String emptyImageIcon = 'assets/icons/empty_image_icon.png';
}

/// Navigation routes between app screens.
final class AppRoutes {
  AppRoutes._();

  static const String signIn = '/signIn';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String productDetails = '/product_details';
  static const String search = '/search';
}
