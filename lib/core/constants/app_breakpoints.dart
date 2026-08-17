import 'package:flutter/material.dart';

abstract class AppBreakpoints {
  static const double mobileMax = 600.0;
  static const double tabletMax = 1024.0;

  static bool isMobile(BoxConstraints constraints) => 
      constraints.maxWidth < mobileMax;

  static bool isTablet(BoxConstraints constraints) => 
      constraints.maxWidth >= mobileMax && constraints.maxWidth < tabletMax;

  static bool isDesktop(BoxConstraints constraints) => 
      constraints.maxWidth >= tabletMax;
}
