import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_colors.dart';
import 'package:juniorflutterroadmap/core/constants/app_typography.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.hasError = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: isLoading ? null : onPressed,
            elevation: 0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            color: hasError ? context.error : context.primary,
            height: 55,
            child: isLoading
                ?  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: context.primary,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    label,
                    style: AppTypography.buttonLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}