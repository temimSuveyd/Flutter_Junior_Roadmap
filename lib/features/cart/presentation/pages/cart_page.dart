import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/utils/app_app_bar.dart';
import 'package:juniorflutterroadmap/core/utils/empty_state.dart';
import 'package:juniorflutterroadmap/features/cart/data/models/cart_item_model.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/widgets/cart_summary_bottom_sheet.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: context.t.cart,
        showBackButton: false,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartPaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.t.paymentSuccess),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartEmpty || state is CartInitial) {
            return EmptyState(
              message: context.t.emptyCart,
            );
          }

          if (state is CartLoaded) {
            return _CartContent(state: state);
          }

          if (state is CartProcessing) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: context.spacing.spaceLg),
                  Text(
                    context.t.processingPayment,
                    style: context.typography.titleMedium,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent({required this.state});

  final CartLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.spaceMd,
              vertical: context.spacing.spaceSm,
            ),
            itemCount: state.items.length,
            separatorBuilder: (context, index) => SizedBox(
              height: context.spacing.spaceSm,
            ),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return _CartItemTile(item: item);
            },
          ),
        ),
        _CartSummary(total: state.total),
      ],
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.spaceLg,
        ),
        decoration: BoxDecoration(
          color: context.colors.error,
          borderRadius: context.radius.md,
        ),
        child: const Icon(
          IconsaxPlusBold.trash,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) {
        context.read<CartBloc>().add(CartItemRemoved(item.id));
      },
      child: Container(
        padding: EdgeInsets.all(context.spacing.spaceMd),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: context.radius.md,
          border: Border.all(
            color: context.colors.border,
          ),
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: context.radius.sm,
              child: Image.network(
                item.image.firstOrNull ?? '',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 64,
                  height: 64,
                  color: context.colors.surface,
                  child: Icon(
                    IconsaxPlusLinear.image,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ),
            SizedBox(width: context.spacing.spaceMd),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: context.typography.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.spacing.spaceXs),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: context.typography.titleMedium.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            _QuantityControls(item: item),
          ],
        ),
      ),
    );
  }
}

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: context.radius.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: IconsaxPlusLinear.minus,
            onTap: () {
              context.read<CartBloc>().add(
                    CartQuantityDecreased(item.id),
                  );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.spaceSm,
            ),
            child: Text(
              '${item.quantity}',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _QuantityButton(
            icon: IconsaxPlusLinear.add,
            onTap: () {
              context.read<CartBloc>().add(
                    CartQuantityIncreased(item.id),
                  );
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.spacing.spaceXs),
        child: Icon(
          icon,
          size: 18,
          color: context.colors.textPrimary,
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.total});

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
            // Total
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

            // Checkout Button
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
                  foregroundColor: Colors.white,
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
                    color: Colors.white,
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
