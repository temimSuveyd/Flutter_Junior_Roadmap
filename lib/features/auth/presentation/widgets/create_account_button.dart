import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_colors.dart';
import 'package:juniorflutterroadmap/core/constants/app_typography.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have account",
          style: AppTypography.bodySmall.copyWith(
            color: context.textSecondary,
            fontWeight: FontWeight.w300,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Create account',
            style: AppTypography.labelSmall.copyWith(
              color: context.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}