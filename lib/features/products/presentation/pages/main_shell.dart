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

/// Single source of truth for the bottom navigation tabs.
/// Add a new tab here and the nav bar updates automatically.
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
    route: AppRoutes.profile,
    icon: IconsaxPlusLinear.profile,
    selectedIcon: IconsaxPlusBold.profile,
    label: (context) => context.t.profile,
  ),
];

class _MainNavigationBar extends StatefulWidget {
  const _MainNavigationBar();

  @override
  State<_MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<_MainNavigationBar> {
  int? _pendingIndex;

  int _indexFor(String location) {
    final index = _tabs.indexWhere((tab) => tab.route == location);
    return index == -1 ? 0 : index;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    if (_pendingIndex == index) return;
    setState(() => _pendingIndex = index);
    context.go(_tabs[index].route);
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
      backgroundColor: context.colors.background,
      indicatorColor: context.colors.primary.withValues(alpha: 0.5),
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
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
