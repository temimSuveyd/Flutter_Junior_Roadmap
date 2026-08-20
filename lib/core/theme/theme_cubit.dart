import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_loadInitialTheme(_prefs));

  final SharedPreferences _prefs;
  static const String _themeModeKey = 'theme_mode';

  static ThemeMode _loadInitialTheme(SharedPreferences prefs) {
    final saved = prefs.getString(_themeModeKey);
    return saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _prefs.setString(
      _themeModeKey,
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
    emit(newMode);
  }
}