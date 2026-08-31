import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/utils/empty_state.dart';
import 'package:juniorflutterroadmap/features/favorites/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/product_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.spaceLg,
                vertical: context.spaceMd,
              ),
              child: Text(
                context.t.favorites,
                style: context.typography.headlineMedium,
              ),
            ),
            Expanded(
              child: BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  return switch (state) {
                    FavoriteInitial() => const SizedBox.shrink(),
                    FavoritesEmpty() => EmptyState(
                        message: context.t.noFavorites,
                      ),
                    FavoritesLoadedState(:final favorites) => _FavoritesGrid(
                        favorites: favorites,
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid({required this.favorites});

  final List<ProductModel> favorites;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(context.spaceLg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsive.isMobile ? 2 : 4,
        childAspectRatio: 0.7,
        crossAxisSpacing: context.spaceMd,
        mainAxisSpacing: context.spaceMd,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final product = favorites[index];
        final String heroTag = 'favorites_${product.id}';
        return Hero(
          tag: heroTag,
          child: ProductCard(
            product: product,
            onTap: () => context.push(
              AppRoutes.productDetails,
              extra: {'id': product.id, 'hero_tag': heroTag},
            ),
          ),
        );
      },
    );
  }
}
