import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/helpers/helpers.dart';
import '../../../../core/utils/empty_state.dart';
import '../../../../core/utils/error_state.dart';
import '../../../../core/utils/loading_state.dart';
import '../bloc/product_bloc.dart';
import 'mobile/phone_product_grid.dart';
import 'shared/banner_slider.dart';
import 'shared/category_list.dart';
import 'shared/home_header.dart';
import 'shared/home_search_bar.dart';

class MobileContant extends StatelessWidget {
  const MobileContant({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                return SliverToBoxAdapter(
                  child: LoadingState(message: context.t.loadingProducts),
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
                  return SliverToBoxAdapter(
                    child: EmptyState(message: context.t.noProducts),
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