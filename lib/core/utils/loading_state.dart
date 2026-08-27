import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

class LoadingState extends StatelessWidget {

  const LoadingState({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.insetXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: context.colors.primary),
            if (message != null) ...[
              context.vGapMd,
              Text(
                message!,
                textAlign: TextAlign.center,
                style: context.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}