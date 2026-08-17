import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  // نبدأ بالوضع الافتراضي (مثلاً Light)
  ThemeCubit() : super(ThemeMode.light);

  // دالة لتبديل الثيم
  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }
}
