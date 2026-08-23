import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.t.dontHaveAccount,
          style: context.bodySmall.copyWith(
            color: context.textSecondary,
            fontWeight: FontWeight.w300,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            context.t.createAccount,
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