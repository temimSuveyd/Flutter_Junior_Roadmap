import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/utils/app_network_image.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:juniorflutterroadmap/features/products/presentation/bloc/product_bloc/product_bloc.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) =>
          (previous is ProductLoaded ? previous.products : const []) !=
          (current is ProductLoaded ? current.products : const []),
      builder: (context, state) {
        final products = state is ProductLoaded
            ? state.products
            : const <ProductModel>[];
        final banners = products.take(5).toList();

        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1,
            autoPlay: true,
            padEnds: false,
          ),
          itemBuilder: (context, index, realIndex) {
            final product = banners[index];
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: product.thumbnailImage == null
                      ? context.surface
                      : null,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (product.thumbnailImage != null)
                        Positioned.fill(
                          child: AppNetworkImage(
                            url: product.thumbnailImage!,
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: context.titleMedium.copyWith(
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: context.titleSmall.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
