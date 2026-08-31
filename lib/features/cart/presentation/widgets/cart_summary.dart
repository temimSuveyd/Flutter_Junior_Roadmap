import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/widgets/cart_summary_bottom_sheet.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.spaceMd),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          top: BorderSide(
            color: context.colors.border,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.t.total,
                  style: context.typography.bodyMedium.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: context.typography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(width: context.spacing.spaceLg),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => CartSummaryBottomSheet(total: total),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.background,
                  padding: EdgeInsets.symmetric(
                    vertical: context.spacing.spaceMd,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: context.radius.md,
                  ),
                ),
                child: Text(
                  context.t.showDetails,
                  style: context.typography.titleMedium.copyWith(
                    color: context.colors.background,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
