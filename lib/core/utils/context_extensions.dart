import 'package:flutter/material.dart';

extension BuildContextEntension on BuildContext {
  // Returns the keyboard height.
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  // Returns whether the keyboard is open.
  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
}
