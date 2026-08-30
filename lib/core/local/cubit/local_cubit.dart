import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared_prefs_locale_repository.dart';

part 'local_state.dart';

/// Cubit responsible for managing the app's current locale.
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._repository) : super(const LocaleState()) {
    _loadSavedLocale();
  }

  final LocaleRepository _repository;

  /// Loads the saved locale from local storage.
  Future<void> _loadSavedLocale() async {
    final code = await _repository.getLocaleCode();
    if (code != null) {
      emit(LocaleState(Locale(code)));
    }
  }

  /// Changes the locale and saves it locally.
  Future<void> changeLocale(String languageCode) async {
    await _repository.saveLocaleCode(languageCode);
    emit(LocaleState(Locale(languageCode)));
  }
}
