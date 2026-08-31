import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/features/cart/data/models/cart_item_model.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/widgets/quantity_button.dart';

class QuantityControls extends StatelessWidget {
  const QuantityControls({super.key, required this.item});

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
          QuantityButton(
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
          QuantityButton(
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
