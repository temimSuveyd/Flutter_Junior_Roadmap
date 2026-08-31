import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/widgets/cart_summary.dart';

class CartContent extends StatelessWidget {
  const CartContent({super.key, required this.state});

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
              return CartItemTile(item: item);
            },
          ),
        ),
        CartSummary(total: state.total),
      ],
    );
  }
}
