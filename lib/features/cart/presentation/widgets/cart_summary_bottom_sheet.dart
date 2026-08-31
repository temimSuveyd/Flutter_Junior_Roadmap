import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/bloc/cart_bloc/cart_bloc.dart';

class CartSummaryBottomSheet extends StatelessWidget {
  const CartSummaryBottomSheet({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.spaceLg),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartPaymentSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final isProcessing = state is CartProcessing;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2),
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
                    _SummaryRow(
                      label: context.t.subtotal,
                      value: '\$${total.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: context.spacing.spaceSm),
                    _SummaryRow(
                      label: context.t.shipping,
                      value: context.t.free,
                    ),
                    Divider(
                      color: context.colors.border,
                      height: context.spacing.spaceMd,
                    ),
                    _SummaryRow(
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
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        context.colors.primary.withValues(alpha: 0.5),
                    padding: EdgeInsets.symmetric(
                      vertical: context.spacing.spaceMd,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: context.radius.md,
                    ),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              IconsaxPlusLinear.card,
                              color: Colors.white,
                            ),
                            SizedBox(width: context.spacing.spaceSm),
                            Text(
                              context.t.payNow,
                              style: context.typography.titleMedium.copyWith(
                                color: Colors.white,
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isBold
                  ? context.typography.titleMedium
                  : context.typography.bodyMedium)
              .copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: (isBold
                  ? context.typography.titleMedium
                  : context.typography.bodyMedium)
              .copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? context.colors.primary : null,
          ),
        ),
      ],
    );
  }
}
