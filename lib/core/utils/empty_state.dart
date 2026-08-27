import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

class EmptyState extends StatelessWidget {

  const EmptyState({super.key, required this.message, this.action});
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.insetXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconsaxPlusLinear.box,
              size: 64,
              color: context.colors.textSecondary,
            ),
            context.vGapMd,
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            if (action != null) ...[
              context.vGapLg,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}