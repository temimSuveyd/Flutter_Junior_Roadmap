import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/features/cart/data/models/cart_item_model.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/widgets/quantity_controls.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});

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
            QuantityControls(item: item),
          ],
        ),
      ),
    );
  }
}
