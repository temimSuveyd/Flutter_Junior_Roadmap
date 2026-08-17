import 'package:flutter/material.dart';
import '../shared/product_card.dart';

class MobileProductGrid extends StatelessWidget {
  const MobileProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: 10,
      itemBuilder: (context, index) => const ProductCard(),
    );
  }
}