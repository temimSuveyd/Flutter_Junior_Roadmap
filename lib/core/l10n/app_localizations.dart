import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// واجهة الوصول إلى النصوص المترجمة عبر `AppLocalizations.of(context)`.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  // ── المصادقة ──
  String get loginTitle;
  String get loginButton;
  String get signIn;
  String get signUp;
  String get createAccount;
  String get email;
  String get password;
  String get confirmPassword;
  String get name;
  String get forgotPassword;
  String get alreadyHaveAccount;
  String get dontHaveAccount;

  // ── رسائل التحقق ──
  String get pleaseEnterName;
  String get pleaseConfirmPassword;
  String get passwordsDoNotMatch;
  String get pleaseEnterEmail;
  String get invalidEmail;
  String get pleaseEnterPassword;
  String get passwordTooShort;
  String get accountCreated;

  // ── التنقل ──
  String get home;
  String get profile;
  String get search;
  String get all;

  // ── حالات التحميل ──
  String get loadingProducts;
  String get noProducts;
  String get loadingProfile;
  String get emptyList;
  String get productDetails;
  String get searchHint;
  String get locationPermissionDenied;
  String get locationError;
  String get addressTitle;
  String get addressHint;
  String get cityLabel;
  String get addressLabel;
  String get saveAddress;
  String get useMyLocation;

  // ── أزرار عامة ──
  String get retry;

  // ── الملف الشخصي ──
  String get camera;
  String get gallery;
  String get removePhoto;
  String get removePhotoConfirm;
  String get cancel;
  String get remove;
  String get changePhoto;
  String get anonymousUser;
  String get permissionDenied;
  String get noImageSelected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale".',
  );
}
