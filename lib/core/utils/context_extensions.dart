import 'package:flutter/material.dart';

extension BuildContextEntension on BuildContext {
  // Klavyenin yüksekliğini verir
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  // Klavyenin açık olup olmadığını bool olarak döner
  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
}
