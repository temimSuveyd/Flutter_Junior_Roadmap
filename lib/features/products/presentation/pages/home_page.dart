import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorflutterroadmap/core/constants/app_breakpoints.dart';
import 'package:juniorflutterroadmap/core/di/injection.dart';
import 'package:juniorflutterroadmap/features/products/presentation/bloc/product_bloc.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/mobile_home_body.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/tablet_home_body.dart';

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