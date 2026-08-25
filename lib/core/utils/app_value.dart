import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

/// Read-only label/value display that follows the app design system.
class AppValue extends StatelessWidget {
  const AppValue({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: context.textSecondary),
              const SizedBox(width: 6),
            ],
            Text(
              label.toUpperCase(),
              style: context.labelSmall.copyWith(
                color: context.textSecondary,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value.isNotEmpty ? value : '-',
          style: context.bodyMedium.copyWith(color: context.textPrimary),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
