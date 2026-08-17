import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_colors.dart';
import 'package:juniorflutterroadmap/core/constants/app_typography.dart';

class CreateAccountSubmitButton extends StatelessWidget {
  const CreateAccountSubmitButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: onPressed,
            elevation: 0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            color: context.primary,
            height: 55,
            child: Text(
              'Create account',
              style: AppTypography.buttonLarge.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}