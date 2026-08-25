import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/di/injection.dart';
import 'package:juniorflutterroadmap/core/utils/error_state.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:juniorflutterroadmap/features/products/data/repositories/product_repositories.dart';
import 'package:juniorflutterroadmap/features/products/presentation/bloc/product_details_bloc/product_details_bloc.dart';
import '../widgets/mobile/product_details_mobile_body.dart';
import '../widgets/tablet/product_details_tablet_body.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, this.product, this.productId});

  final ProductModel? product;
  final int? productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsBloc(
        getIt<ProductRepository>(),
        product: product,
        productId: productId,
      )..add(ProductDetailsRequested()),
      child: const _ProductDetailsView(),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  const _ProductDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(context.isRtl ? Icons.arrow_forward : Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.l10n.t.productDetails,
          style: context.typography.titleMedium,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          builder: (context, state) {
            if (state is ProductDetailsError) {
              return ErrorState(
                message: state.message,
                onRetry: () => context
                    .read<ProductDetailsBloc>()
                    .add(ProductDetailsRequested()),
              );
            }
            if (state is ProductDetailsLoaded) {
              return context.responsive.isMobile
                  ? ProductDetailsMobileBody(product: state.product)
                  : ProductDetailsTabletBody(product: state.product);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
