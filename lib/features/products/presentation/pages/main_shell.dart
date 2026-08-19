import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/common/helpers/helpers.dart';

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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: context.background,
      indicatorColor: context.primary.withValues(alpha: 0.5),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(IconsaxPlusLinear.home_2),
          selectedIcon: Icon(IconsaxPlusBold.home_2),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(IconsaxPlusLinear.bag_2),
          selectedIcon: Icon(IconsaxPlusBold.bag_2),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(IconsaxPlusLinear.profile),
          selectedIcon: Icon(IconsaxPlusBold.profile),
          label: 'Profile',
        ),
      ],
    );
  }
}
