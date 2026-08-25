import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Input validation helpers with localization support.
class AppValidators {
  /// Email validator.
  static String? validateEmail(BuildContext context, String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return t.pleaseEnterEmail;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return t.invalidEmail;
    }

    return null;
  }

  /// Password validator.
  static String? validatePassword(BuildContext context, String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return t.pleaseEnterPassword;
    }

    if (value.length < 6) {
      return t.passwordTooShort;
    }

    return null;
  }

  /// Username validator.
  static String? validateName(BuildContext context, String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return t.pleaseEnterName;
    }
    return null;
  }

  /// Confirm-password validator.
  static String? validateConfirmPassword(
    BuildContext context,
    String? value,
    String password,
  ) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return t.pleaseConfirmPassword;
    }
    if (value != password) {
      return t.passwordsDoNotMatch;
    }
    return null;
  }
}
