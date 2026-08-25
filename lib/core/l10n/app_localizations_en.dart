// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// ترجمات اللغة الإنجليزية.
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  // ── المصادقة ──
  @override
  String get loginTitle => 'Welcome Back';
  @override
  String get loginButton => 'Sign In';
  @override
  String get signIn => 'Sign In';
  @override
  String get signUp => 'Sign Up';
  @override
  String get createAccount => 'Create Account';
  @override
  String get email => 'email';
  @override
  String get password => 'password';
  @override
  String get confirmPassword => 'confirm password';
  @override
  String get name => 'name';
  @override
  String get forgotPassword => 'Forget password';
  @override
  String get alreadyHaveAccount => 'Already have account';
  @override
  String get dontHaveAccount => "Don't have account";

  // ── رسائل التحقق ──
  @override
  String get pleaseEnterName => 'Please enter your name';
  @override
  String get pleaseConfirmPassword => 'Please confirm your password';
  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
  @override
  String get pleaseEnterEmail => 'Please enter your e-mail address';
  @override
  String get invalidEmail => 'Please enter a valid email address';
  @override
  String get pleaseEnterPassword => 'Please enter your password';
  @override
  String get passwordTooShort =>
      'Password must consist of at least 6 characters';
  @override
  String get accountCreated => 'Account created. Please sign in.';

  // ── التنقل ──
  @override
  String get home => 'Home';
  @override
  String get profile => 'Profile';
  @override
  String get search => 'Search..';

  // ── حالات التحميل ──
  @override
  String get loadingProducts => 'Loading products...';
  @override
  String get noProducts => 'No products available';
  @override
  String get loadingProfile => 'Loading profile...';
  @override
  String get emptyList => 'You have reached the end of the list';
  @override
  String get productDetails => 'Product Details';
  @override
  String get searchHint => 'Search products...';
  @override
  String get locationPermissionDenied => 'Location permission denied';
  @override
  String get locationError => 'Could not detect your location';
  @override
  String get addressTitle => 'Your Address';
  @override
  String get addressHint => 'Enter your delivery address details';
  @override
  String get cityLabel => 'City';
  @override
  String get addressLabel => 'Address';
  @override
  String get saveAddress => 'Save Address';
  @override
  String get useMyLocation => 'Use my location';

  // ── أزرار عامة ──
  @override
  String get retry => 'Retry';

  // ── الملف الشخصي ──
  @override
  String get camera => 'Camera';
  @override
  String get gallery => 'Gallery';
  @override
  String get removePhoto => 'Remove photo';
  @override
  String get removePhotoConfirm =>
      'Are you sure you want to remove your profile photo?';
  @override
  String get cancel => 'Cancel';
  @override
  String get remove => 'Remove';
  @override
  String get changePhoto => 'Change photo';
  @override
  String get anonymousUser => 'Anonymous User';
  @override
  String get permissionDenied =>
      'Permission denied. Enable it in device settings.';
  @override
  String get noImageSelected => 'No image selected';
}
