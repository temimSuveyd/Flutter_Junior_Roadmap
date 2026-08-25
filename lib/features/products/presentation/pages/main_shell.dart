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

class _MainNavigationBar extends StatefulWidget {
  const _MainNavigationBar();

  @override
  State<_MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<_MainNavigationBar> {
  int? _pendingIndex;

  int _indexFor(String location) {
    if (location == AppRoutes.profile) {
      return 1;
    }
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    if (_pendingIndex == index) return;
    setState(() => _pendingIndex = index);
    final target = switch (index) {
      1 => AppRoutes.profile,
      _ => AppRoutes.home,
    };
    context.go(target);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final actualIndex = _indexFor(location);
    if (_pendingIndex != null && _pendingIndex == actualIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _pendingIndex = null);
        }
      });
    }
    final selectedIndex = _pendingIndex ?? actualIndex;
    return NavigationBar(
      backgroundColor: context.background,
      indicatorColor: context.primary.withValues(alpha: 0.5),
      selectedIndex: selectedIndex,
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