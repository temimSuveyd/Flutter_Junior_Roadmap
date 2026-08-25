import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

import '../../../data/models/product_model.dart';
import '../shared/product_details_gallery.dart';
import '../shared/product_details_info.dart';

class ProductDetailsMobileBody extends StatelessWidget {
  const ProductDetailsMobileBody({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.spacing.insetMd,
      child: Column(
        children: [
          SizedBox(
            height: 320,
            child: ProductDetailsGallery(images: product.image.cast<String>()),
          ),
          context.spacing.vGapLg,
          ProductDetailsInfo(product: product),
        ],
      ),
    );
  }
}
