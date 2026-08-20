export 'app_colors.dart';
export 'app_spacing.dart';
export 'app_typography.dart';

/// ثوابت عامة للتخطيط والترقيم والمدد الزمنية للحركات.
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

/// مسارات أصول الوسائط (صور وأيقونات) المستخدمة في التطبيق.
final class AppAssets {
  AppAssets._();

  static const String logo = 'assets/images/logo.png';
  static const String logoOutline = 'assets/images/log_outline.png';
  static const String pdfIcon = 'assets/icons/pdf_icon.png';
  static const String quizIcon = 'assets/icons/quiz_icon.png';
}

/// صور مخصصة للشاشات مثل صفحة المصادقة.
final class AppImages {
  AppImages._();

  static const String authPages = 'assets/images/auth_pages.png';
}


/// مسارات التنقل بين شاشات التطبيق.
final class AppRoutes {
  AppRoutes._();

  static const String signIn = '/signIn';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String productDetails = '/product_details';
}
