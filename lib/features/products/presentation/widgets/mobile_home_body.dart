import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorflutterroadmap/core/common/widgets/empty_state.dart';
import 'package:juniorflutterroadmap/core/common/widgets/error_state.dart';
import 'package:juniorflutterroadmap/core/common/widgets/loading_state.dart';
import 'package:juniorflutterroadmap/features/products/presentation/bloc/product_bloc.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/mobile/phone_product_grid.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/banner_slider.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/category_list.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/home_header.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/home_search_bar.dart';

class MobileContant extends StatelessWidget {
  const MobileContant({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: const HomeHeader(),
            ),
          ),

          const SliverPersistentHeader(
            pinned: true,
            delegate: HomeSearchBarHeaderDelegate(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),

          const SliverToBoxAdapter(child: BannerSlider()),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),

          const SliverToBoxAdapter(child: CategoryList()),

          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const SliverToBoxAdapter(
                  child: LoadingState(message: 'Loading products...'),
                );
              }
              if (state is ProductError) {
                return SliverToBoxAdapter(
                  child: ErrorState(
                    message: state.message,
                    onRetry: () =>
                        context.read<ProductBloc>().add(ProductsRequested()),
                  ),
                );
              }
              if (state is ProductLoaded) {
                if (state.products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: EmptyState(message: 'No products available'),
                  );
                }
                return MobileProductGrid(products: state.products);
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}