import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/widgets/summary_row.dart';

class CartSummaryBottomSheet extends StatelessWidget {
  const CartSummaryBottomSheet({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.spaceLg),
      decoration: BoxDecoration(
        color: context.colors.background,

        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXxl),
        ),
      ),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          context.pop();
        },
        builder: (context, state) {
          final isProcessing = state is CartProcessing;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                width: context.spacing.spaceXl,
                height: context.spacing.spaceXs,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: context.radius.xs,
                ),
              ),
              SizedBox(height: context.spacing.spaceLg),

              // Title
              Text(
                context.t.orderSummary,
                style: context.typography.titleLarge,
              ),
              SizedBox(height: context.spacing.spaceMd),

              // Order Details
              Container(
                padding: EdgeInsets.all(context.spacing.spaceMd),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: context.radius.md,
                ),
                child: Column(
                  children: [
                    SummaryRow(
                      label: context.t.subtotal,
                      value: '\$${total.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: context.spacing.spaceSm),
                    SummaryRow(
                      label: context.t.shipping,
                      value: context.t.free,
                    ),
                    Divider(
                      color: context.colors.border,
                      height: context.spacing.spaceMd,
                    ),
                    SummaryRow(
                      label: context.t.total,
                      value: '\$${total.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.spacing.spaceLg),

              // Payment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () {
                          context.read<CartBloc>().add(CheckoutRequested());
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.background,
                    disabledBackgroundColor: context.colors.primary.withValues(
                      alpha: 0.5,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: context.spacing.spaceMd,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: context.radius.md,
                    ),
                  ),
                  child: isProcessing
                      ?  SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.colors.background,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Icon(
                              IconsaxPlusLinear.card,
                              color: context.colors.background,
                            ),
                            SizedBox(width: context.spacing.spaceSm),
                            Text(
                              context.t.payNow,
                              style: context.typography.titleMedium.copyWith(
                                color: context.colors.background,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
