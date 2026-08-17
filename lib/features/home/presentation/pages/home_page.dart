import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_breakpoints.dart';
import 'package:juniorflutterroadmap/features/home/presentation/widgets/mobile_home_body.dart';
import 'package:juniorflutterroadmap/features/home/presentation/widgets/tablet_home_body.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (AppBreakpoints.isMobile(constraints)) {
              return MobileContant();
            }
            if (AppBreakpoints.isTablet(constraints)) {
              return TabletContant();
            }
            return TabletContant();
          },
          ),
      ),
    );
  }
}


