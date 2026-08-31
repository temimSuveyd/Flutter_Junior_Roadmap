import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/utils/app_network_image.dart';
import 'package:juniorflutterroadmap/features/favorites/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});
  final ProductModel product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoriteBloc, bool>(
      (bloc) => bloc.state.favoriteIds.contains(product.id),
    );

    return GestureDetector(
      onTap: onTap,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: context.radius.lg,
                color: context.colors.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: context.radius.lg,
                      child: AppNetworkImage(
                        url: product.thumbnailImage!,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(context.spacing.spaceMd),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${product.price}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ...List.generate(
                              3,
                              (colorIndex) => Container(
                                margin: const EdgeInsetsDirectional.only(
                                  end: 1,
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: colorIndex == 0
                                        ? context.colors.textPrimary
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
                ],
              ),
            ),
            PositionedDirectional(
              top: 0,
              end: 0,
              child: GestureDetector(
                onTap: () {
                  context.read<FavoriteBloc>().add(FavoriteToggled(product));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isFavorite
                        ? context.colors.primary
                        : context.colors.primary.withValues(alpha: 0.7),
                    borderRadius: BorderRadiusDirectional.only(
                      topEnd: context.radius.lg.topLeft,
                      bottomStart: context.radius.lg.bottomRight,
                    ),
                  ),
                  child: Icon(
                    isFavorite
                        ? IconsaxPlusBold.heart
                        : IconsaxPlusLinear.heart,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
