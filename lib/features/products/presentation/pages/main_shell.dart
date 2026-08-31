import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _PlatformAdaptiveShell(child: child);
  }
}

class _PlatformAdaptiveShell extends StatefulWidget {
  const _PlatformAdaptiveShell({required this.child});

  final Widget child;

  @override
  State<_PlatformAdaptiveShell> createState() =>
      _PlatformAdaptiveShellState();
}

class _PlatformAdaptiveShellState extends State<_PlatformAdaptiveShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _indexFor(location);
    if (_selectedIndex != currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedIndex = currentIndex);
      });
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    // iOS → CupertinoTabBar (native look)
    if (Platform.isIOS) {
      return CupertinoTabBar(
        backgroundColor: context.colors.background,
        activeColor: context.colors.primary,
        inactiveColor: context.colors.textSecondary,
        border: Border(
          top: BorderSide(color: context.colors.border, width: 0.5),
        ),
        currentIndex: _selectedIndex,
        onTap: (index) => context.go(_tabs[index].route),
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              activeIcon: Icon(tab.selectedIcon),
              label: tab.label(context),
            ),
        ],
      );
    }

    // Android → Material NavigationBar (native look)
    return NavigationBar(
      backgroundColor: context.colors.background,
      indicatorColor: context.colors.primary.withValues(alpha: 0.5),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => context.go(_tabs[index].route),
      destinations: [
        for (final tab in _tabs)
          NavigationDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.selectedIcon),
            label: tab.label(context),
          ),
      ],
    );
  }
}

// ── Tab Definitions ──────────────────────────────────────────────────────────

class _NavTab {
  const _NavTab({
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String Function(BuildContext context) label;
}

final List<_NavTab> _tabs = [
  _NavTab(
    route: AppRoutes.home,
    icon: IconsaxPlusLinear.home_2,
    selectedIcon: IconsaxPlusBold.home_2,
    label: (context) => context.t.home,
  ),
  _NavTab(
    route: AppRoutes.favorites,
    icon: IconsaxPlusLinear.heart,
    selectedIcon: IconsaxPlusBold.heart,
    label: (context) => context.t.favorites,
  ),
  _NavTab(
    route: AppRoutes.cart,
    icon: IconsaxPlusLinear.shopping_cart,
    selectedIcon: IconsaxPlusBold.shopping_cart,
    label: (context) => context.t.cart,
  ),
  _NavTab(
    route: AppRoutes.profile,
    icon: IconsaxPlusLinear.profile,
    selectedIcon: IconsaxPlusBold.profile,
    label: (context) => context.t.profile,
  ),
];

int _indexFor(String location) {
  final index = _tabs.indexWhere((tab) => tab.route == location);
  return index == -1 ? 0 : index;
}
