import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared_prefs_locale_repository.dart';

part 'local_state.dart';

/// Cubit مسؤول عن إدارة اللغة الحالية في التطبيق.
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._repository)
      : super(const LocaleState()) {
    _loadSavedLocale();
  }

  final LocaleRepository _repository;

  /// تحميل اللغة المحفوظة من التخزين المحلي.
  Future<void> _loadSavedLocale() async {
    final code = await _repository.getLocaleCode();
    if (code != null) {
      emit(LocaleState(Locale(code)));
    }
  }

  /// تغيير اللغة وحفظها محلياً.
  Future<void> changeLocale(String languageCode) async {
    await _repository.saveLocaleCode(languageCode);
    emit(LocaleState(Locale(languageCode)));
  }
}
