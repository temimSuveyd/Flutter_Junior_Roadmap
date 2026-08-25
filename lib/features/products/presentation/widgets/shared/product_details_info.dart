import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

import '../../../data/models/product_model.dart';

class ProductDetailsInfo extends StatelessWidget {
  const ProductDetailsInfo({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(borderRadius: context.radius.lg),
      elevation: 0,
      child: Padding(
        padding: context.spacing.insetLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductDetailsTitle(title: product.title),
            context.spacing.vGapSm,
            ProductDetailsPrice(price: product.price),
            context.spacing.vGapMd,
            ProductDetailsCategory(category: product.category),
            context.spacing.vGapMd,
            ProductDetailsDescription(description: product.description),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsTitle extends StatelessWidget {
  const ProductDetailsTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: context.typography.titleLarge.copyWith(fontWeight: FontWeight.bold),
      );
}

class ProductDetailsPrice extends StatelessWidget {
  const ProductDetailsPrice({super.key, required this.price});
  final double price;

  @override
  Widget build(BuildContext context) => Text(
        '\$${price.toStringAsFixed(2)}',
        style: context.typography.titleMedium.copyWith(color: context.colors.primary),
      );
}

class ProductDetailsCategory extends StatelessWidget {
  const ProductDetailsCategory({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) => Chip(
        label: Text(category, style: context.typography.labelSmall),
        backgroundColor: context.colors.primary.withValues(alpha: 0.12),
      );
}

class ProductDetailsDescription extends StatelessWidget {
  const ProductDetailsDescription({super.key, required this.description});
  final String description;

  @override
  Widget build(BuildContext context) => Text(
        description,
        style: context.typography.bodyMedium.copyWith(color: context.colors.textSecondary),
      );
}
