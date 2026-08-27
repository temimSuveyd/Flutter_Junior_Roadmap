import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/utils/animation_extensions.dart';

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
            onPressed: isLoading ? () {} : onPressed,
            elevation: 0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              borderSide: BorderSide.none,
            ),
            color: hasError ? context.colors.error : context.colors.primary,
            height: 55,
            child: AnimatedSwitcher(
              duration: AppDurations.normal,
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: context.colors.surface,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      label,
                      style: context.buttonLarge.copyWith(color: Colors.white),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
