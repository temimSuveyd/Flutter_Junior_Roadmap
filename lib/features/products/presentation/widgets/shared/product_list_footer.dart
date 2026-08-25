import 'package:flutter/material.dart';

import '../../../../../core/common/helpers/helpers.dart';

class ProductListFooter extends StatelessWidget {

  const ProductListFooter({
    super.key,
    required this.isLoadingMore,
    required this.hasReachedMax,
  });
  final bool isLoadingMore;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (hasReachedMax) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            context.l10n.t.emptyList,
            style: context.typography.bodyMedium.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
