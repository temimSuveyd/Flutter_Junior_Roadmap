import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _MainNavigationBar(),
    );
  }
}

class _MainNavigationBar extends StatelessWidget {
  const _MainNavigationBar();

  int _indexFor(String location) {
    if (location == AppRoutes.profile) {
      return 1;
    }
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    final current = GoRouterState.of(context).uri.path;
    final target = switch (index) {
      1 => AppRoutes.profile,
      _ => AppRoutes.home,
    };
    if (current != target) {
      context.go(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return NavigationBar(
      backgroundColor: context.background,
      indicatorColor: context.primary.withValues(alpha: 0.5),
      selectedIndex: _indexFor(location),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: [
        NavigationDestination(
          icon: const Icon(IconsaxPlusLinear.home_2),
          selectedIcon: const Icon(IconsaxPlusBold.home_2),
          label: context.t.home,
        ),
        NavigationDestination(
          icon: const Icon(IconsaxPlusLinear.profile),
          selectedIcon: const Icon(IconsaxPlusBold.profile),
          label: context.t.profile,
        ),
      ],
    );
  }
}