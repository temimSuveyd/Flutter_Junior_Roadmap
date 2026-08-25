import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/helpers/helpers.dart';
import '../../../../core/utils/empty_state.dart';
import '../../../../core/utils/error_state.dart';
import '../../../../core/utils/loading_state.dart';
import '../bloc/product_bloc/product_bloc.dart';
import 'mobile/phone_product_grid.dart';
import 'shared/banner_slider.dart';
import 'shared/category_list.dart';
import 'shared/home_header.dart';
import 'shared/home_search_bar.dart';
import 'shared/product_list_footer.dart';
import 'tablet/tablet_product_grid.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductBloc>().add(ProductsLoadMore());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: HomeHeader(),
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
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            const _ProductRegion(),
          ],
        );
      },
    );
  }
}

class _ProductRegion extends StatelessWidget {
  const _ProductRegion();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return SliverMainAxisGroup(
          slivers: [
            _buildProductContent(context, state),
            _buildFooter(context, state),
          ],
        );
      },
    );
  }

  Widget _buildProductContent(BuildContext context, ProductState state) {
    return switch (state) {
      ProductLoaded(:final products) =>
        context.responsive.isMobile
            ? MobileProductGrid(products: products)
            : TabletProductGrid(products: products),
      ProductInitial() || ProductLoading() => _statusSliver(
        context,
        const LoadingState(),
      ),
      ProductEmpty() => _statusSliver(
        context,
        EmptyState(message: context.l10n.t.noProducts),
      ),
      ProductError(:final message) => _statusSliver(
        context,
        ErrorState(
          message: message,
          onRetry: () => context.read<ProductBloc>().add(ProductsRequested()),
        ),
      ),
    };
  }

  Widget _buildFooter(BuildContext context, ProductState state) {
    return SliverToBoxAdapter(
      child: state is ProductLoaded
          ? ProductListFooter(
              isLoadingMore: state.isLoadingMore,
              hasReachedMax: state.hasReachedMax,
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _statusSliver(BuildContext context, Widget child) {
    final height = context.responsive.screenHeight * 0.55;
    return SliverToBoxAdapter(
      child: SizedBox(height: height, child: child),
    );
  }
}
