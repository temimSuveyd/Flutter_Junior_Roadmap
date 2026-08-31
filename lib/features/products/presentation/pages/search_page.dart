import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/di/injection.dart';
import 'package:juniorflutterroadmap/core/utils/empty_state.dart';
import 'package:juniorflutterroadmap/core/utils/error_state.dart';
import 'package:juniorflutterroadmap/core/utils/loading_state.dart';
import 'package:juniorflutterroadmap/features/products/data/repositories/product_repositories.dart';
import 'package:juniorflutterroadmap/features/products/presentation/bloc/search_product_bloc/search_bloc.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/product_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(getIt<ProductRepository>()),
      child: const _SearchPageView(),
    );
  }
}

class _SearchPageView extends StatefulWidget {
  const _SearchPageView();

  @override
  State<_SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<_SearchPageView> {
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _search(String value) {
    context.read<SearchBloc>().add(Search(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _queryController,
          autofocus: true,
          onChanged: _search,
          style: context.typography.bodyLarge,
          decoration: InputDecoration(
            hintText: context.t.search,
            hintStyle: context.typography.bodyLarge.copyWith(
              color: context.colors.textSecondary,
            ),
            border: InputBorder.none,
            prefixIcon: Icon(
              IconsaxPlusLinear.search_normal_1,
              color: context.colors.textSecondary,
            ),
          ),
        ),
        actions: [
          if (_queryController.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.close,
                color: context.colors.textSecondary,
              ),
              onPressed: () {
                _queryController.clear();
                _search('');
              },
            ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchProductState>(
        builder: (context, state) {
          return switch (state) {
            SearchInitial() => EmptyState(message: context.l10n.t.searchHint),
            SearchLoading() => LoadingState(
              message: context.l10n.t.loadingProducts,
            ),
            SearchError(:final message) => ErrorState(
              message: message,
              onRetry: () =>
                  context.read<SearchBloc>().add(Search(_queryController.text)),
            ),
            SearchEmpty() => EmptyState(message: context.l10n.t.noProducts),
            SearchLoaded(:final products) => CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.responsive.isMobile ? 2 : 4,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final String heroTag = 'search_${product.id}';
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
                  ),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}
