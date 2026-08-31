import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

import '../../../data/models/product_model.dart';
import '../shared/product_details_gallery.dart';
import '../shared/product_details_info.dart';

class ProductDetailsMobileBody extends StatelessWidget {
  const ProductDetailsMobileBody({super.key, required this.product, required this.heroTag});
  final ProductModel product;
final String heroTag ;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.spacing.insetMd,
      child: Column(
        children: [
          Hero(
            tag: heroTag,
            child: Material(
              type: MaterialType.transparency,
              child: SizedBox(
                height: 320,
                child: ProductDetailsGallery(
                  images: product.image.cast<String>(),
                ),
              ),
            ),
          ),
          context.spacing.vGapLg,
          ProductDetailsInfo(product: product),
        ],
      ),
    );
  }
}
