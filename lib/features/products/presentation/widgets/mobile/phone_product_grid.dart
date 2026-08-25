import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
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
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}