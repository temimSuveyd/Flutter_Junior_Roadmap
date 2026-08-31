import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

/// Adaptive AppBar that follows the design system.
/// - Mobile: standard AppBar
/// - Tablet/Desktop: centered title with max width constraint
/// - Automatically uses design system colors, typography, and spacing
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.backgroundColor,
    this.elevation = 0,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final Color? backgroundColor;
  final double elevation;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();

    return AppBar(
      backgroundColor: backgroundColor ?? context.colors.background,
      elevation: elevation,
      centerTitle: context.responsive.isMobile,
      leading: showBackButton && canPop
          ? IconButton(
              icon: Icon(Icons.adaptive.arrow_back),
              onPressed: () => context.pop(),
            )
          : leading,
      title: Text(
        title,
        style: context.typography.titleMedium,
      ),
      actions: actions,
    );
  }
}
