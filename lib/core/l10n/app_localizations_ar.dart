// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// ترجمات اللغة العربية.
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  // ── المصادقة ──
  @override
  String get loginTitle => 'مرحباً بك مجدداً';
  @override
  String get loginButton => 'تسجيل الدخول';
  @override
  String get signIn => 'تسجيل الدخول';
  @override
  String get signUp => 'إنشاء حساب';
  @override
  String get createAccount => 'إنشاء حساب';
  @override
  String get email => 'البريد الإلكتروني';
  @override
  String get password => 'كلمة المرور';
  @override
  String get confirmPassword => 'تأكيد كلمة المرور';
  @override
  String get name => 'الاسم';
  @override
  String get forgotPassword => 'نسيت كلمة المرور';
  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل';
  @override
  String get dontHaveAccount => 'ليس لديك حساب';

  // ── رسائل التحقق ──
  @override
  String get pleaseEnterName => 'يرجى إدخال اسمك';
  @override
  String get pleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';
  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';
  @override
  String get pleaseEnterEmail => 'يرجى إدخال بريدك الإلكتروني';
  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صالح';
  @override
  String get pleaseEnterPassword => 'يرجى إدخال كلمة المرور';
  @override
  String get passwordTooShort =>
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
  @override
  String get accountCreated =>
      'تم إنشاء الحساب. يرجى تسجيل الدخول.';

  // ── التنقل ──
  @override
  String get home => 'الرئيسية';
  @override
  String get profile => 'الملف الشخصي';
  @override
  String get search => 'بحث..';

  // ── حالات التحميل ──
  @override
  String get loadingProducts => 'جاري تحميل المنتجات...';
  @override
  String get noProducts => 'لا توجد منتجات متاحة';
  @override
  String get loadingProfile => 'جاري تحميل الملف الشخصي...';

  // ── أزرار عامة ──
  @override
  String get retry => 'إعادة المحاولة';

  // ── الملف الشخصي ──
  @override
  String get camera => 'الكاميرا';
  @override
  String get gallery => 'المعرض';
  @override
  String get removePhoto => 'حذف الصورة';
  @override
  String get removePhotoConfirm =>
      'هل أنت متأكد أنك تريد حذف صورة ملفك الشخصي؟';
  @override
  String get cancel => 'إلغاء';
  @override
  String get remove => 'حذف';
  @override
  String get changePhoto => 'تغيير الصورة';
  @override
  String get anonymousUser => 'مستخدم مجهول';
  @override
  String get permissionDenied =>
      'تم رفض الإذن. يرجى تمكينه من إعدادات الجهاز.';
  @override
  String get noImageSelected => 'لم يتم اختيار صورة';
}
