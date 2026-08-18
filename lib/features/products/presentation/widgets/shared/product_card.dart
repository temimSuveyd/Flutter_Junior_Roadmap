import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.surface,
          ),
          child: Column(
            children: [
              Image.network(width: 100, product.image),
              const Spacer(),
              Text(
                product.title,

                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: context.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${product.price}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const Spacer(),

                  ...List.generate(
                    3,
                    (colorIndex) => Container(
                      margin: const EdgeInsets.only(right: 1),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorIndex == 0
                              ? context.textPrimary
                              : Colors.transparent,
                          width: 0.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: colorIndex == 0 ? 12 : 15,
                        height: colorIndex == 0 ? 12 : 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: [
                            Colors.red,
                            Colors.amber,
                            Colors.blue,
                            Colors.green,
                          ][colorIndex],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Icon(
              IconsaxPlusLinear.heart,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
