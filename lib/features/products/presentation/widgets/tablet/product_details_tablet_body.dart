import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

import '../../../data/models/product_model.dart';
import '../shared/product_details_gallery.dart';
import '../shared/product_details_info.dart';

class ProductDetailsTabletBody extends StatelessWidget {
  const ProductDetailsTabletBody({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.spacing.insetXl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
         
            child: ProductDetailsGallery(images: product.image.cast<String>()),
          ),
          context.spacing.hGapXl,
          Expanded(
       
            child: SingleChildScrollView(
              child: ProductDetailsInfo(product: product),
            ),
          ),
        ],
      ),
    );
  }
}
