import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/common/helpers/helpers.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Forget password',
            style: context.labelMedium.copyWith(color: context.primary),
          ),
        ),
      ],
    );
  }
}