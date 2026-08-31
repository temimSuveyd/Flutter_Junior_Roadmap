import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import '../../../../../core/constants/app_constants.dart';
import '../shared/product_card.dart';

class MobileProductGrid extends StatelessWidget {
  const MobileProductGrid({super.key, required this.products});
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final int id = products[index].id;
        final ProductModel product = products[index];
        final String heroTag = 'home_$id';
        return Hero(
          tag: heroTag,
          child: ProductCard(
            product: product,
            onTap: () {
              context.push(AppRoutes.productDetails, extra: {'id' : id, 'hero_tag' : heroTag });
            },
          ),
        );
      },
    );
  }
}
