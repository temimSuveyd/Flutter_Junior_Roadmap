import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

class ErrorState extends StatelessWidget {

  const ErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.insetXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconsaxPlusLinear.warning_2,
              size: 64,
              color: context.error,
            ),
            context.vGapMd,
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.bodyMedium.copyWith(
                color: context.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              context.vGapLg,
              FilledButton.tonalIcon(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: context.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(IconsaxPlusLinear.refresh),
                label: Text(context.t.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}