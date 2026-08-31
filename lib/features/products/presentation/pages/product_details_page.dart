import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/utils/app_app_bar.dart';
import 'package:juniorflutterroadmap/core/utils/error_state.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:juniorflutterroadmap/features/favorites/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:juniorflutterroadmap/features/products/presentation/bloc/product_details_bloc/product_details_bloc.dart';
import '../../../../core/utils/loading_state.dart';
import '../widgets/mobile/product_details_mobile_body.dart';
import '../widgets/tablet/product_details_tablet_body.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.heroTag});
final String heroTag ; 
  @override
  Widget build(BuildContext context) =>  _ProductDetailsView(heroTag);
}

class _ProductDetailsView extends StatelessWidget {
  const _ProductDetailsView(this.heroTag);
final String heroTag ; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: context.t.productDetails,
        actions: [
          _AddToCartButton(),
          _FavoriteButton(),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          builder: (context, state) {
            return switch (state) {
              ProductDetailsInitial() => LoadingState(
                message: context.t.loadingProductDetails,
              ),
              ProductDetailsLoading() => LoadingState(
                message: context.t.loadingProductDetails,
              ),

              ProductDetailsError() => ErrorState(
                message: state.message == 'product_not_found'
                    ? context.t.productNotFound
                    : state.message,
                onRetry: () => context.read<ProductDetailsBloc>().add(
                  ProductDetailsRequested(),
                ),
              ),

              ProductDetailsLoaded() =>
                context.responsive.isMobile
                    ? ProductDetailsMobileBody(product: state.product,heroTag: heroTag,)
                    : ProductDetailsTabletBody(product: state.product,heroTag: heroTag,),
            };
          },
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = context.select<ProductDetailsBloc, ProductModel?>(
      (bloc) {
        final state = bloc.state;
        return state is ProductDetailsLoaded ? state.product : null;
      },
    );

    if (product == null) return const SizedBox.shrink();

    return IconButton(
      onPressed: () {
        context.read<CartBloc>().add(CartItemAdded(product));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.addedToCart),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      icon: Icon(
        IconsaxPlusLinear.shopping_cart,
        color: context.colors.textSecondary,
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = context.select<ProductDetailsBloc, ProductModel?>(
      (bloc) {
        final state = bloc.state;
        return state is ProductDetailsLoaded ? state.product : null;
      },
    );

    if (product == null) return const SizedBox.shrink();

    final isFavorite = context.select<FavoriteBloc, bool>(
      (bloc) => bloc.state.favoriteIds.contains(product.id),
    );

    return IconButton(
      onPressed: () {
        context.read<FavoriteBloc>().add(FavoriteToggled(product));
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isFavorite ? IconsaxPlusBold.heart : IconsaxPlusLinear.heart,
          key: ValueKey(isFavorite),
          color: isFavorite ? context.colors.primary : context.colors.textSecondary,
        ),
      ),
    );
  }
}
