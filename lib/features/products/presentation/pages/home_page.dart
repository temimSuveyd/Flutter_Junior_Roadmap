import 'package:flutter/material.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../widgets/mobile_home_body.dart';
import '../widgets/tablet_home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (AppBreakpoints.isMobile(constraints)) {
              return const MobileContant();
            }
            if (AppBreakpoints.isTablet(constraints)) {
              return const TabletContant();
            }
            return const TabletContant();
          },
        ),
      ),
    );
  }
}