import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

class AlreadyHaveAccountButton extends StatelessWidget {
  const AlreadyHaveAccountButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have account',
          style: context.bodySmall.copyWith(
            color: context.textSecondary,
            fontWeight: FontWeight.w300,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Sign in',
            style: context.labelSmall.copyWith(
              color: context.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}