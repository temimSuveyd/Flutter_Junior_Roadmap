import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';

import '../../../../../core/errors/result.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repositories.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._productRepository) : super(const ProductInitial()) {
    on<ProductsRequested>(_onProductsRequested, transformer: restartable());
    on<ProductsLoadMore>(_onProductsLoadMore, transformer: droppable());
    on<CategoryRequested>(_onCategoryRequested, transformer: droppable());
    on<CategorySelected>(_onCategorySelected, transformer: restartable());
  }
  final ProductRepository _productRepository;
  static const int _limit = 10;

  Future<void> _onProductsRequested(
    ProductsRequested event,
    Emitter<ProductState> emit,
  ) async {
    final currentCategories = state.categories;
    final currentCategoryId = state.selectedCategoryId;
    emit(ProductLoading(selectedCategoryId: currentCategoryId));

    final result = await _productRepository.getProducts(
      categoryId: currentCategoryId,
    );

    var categories = currentCategories;
    if (categories.isEmpty) {
      final categoryResult = await _productRepository.getCategories();
      if (categoryResult case Success(:final data)) {
        categories = data;
      }
    }

    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(ProductEmpty(
            categories: categories,
            selectedCategoryId: currentCategoryId,
          ));
        } else {
          emit(ProductLoaded(
            data,
            hasReachedMax: data.length < _limit,
            categories: categories,
            selectedCategoryId: currentCategoryId,
          ));
        }
      case Error(:final error):
        emit(ProductError(
          error.message,
          categories: categories,
          selectedCategoryId: currentCategoryId,
        ));
    }
  }

  Future<void> _onCategorySelected(
    CategorySelected event,
    Emitter<ProductState> emit,
  ) async {
    final currentCategories = state.categories;
    emit(ProductLoading(selectedCategoryId: event.categoryId));
    final result = event.categoryId == null
        ? await _productRepository.getProducts()
        : await _productRepository.getProductsByCategory(event.categoryId!);
    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(ProductEmpty(
            categories: currentCategories,
            selectedCategoryId: event.categoryId,
          ));
        } else {
          emit(ProductLoaded(
            data,
            hasReachedMax: true,
            categories: currentCategories,
            selectedCategoryId: event.categoryId,
          ));
        }
      case Error(:final error):
        emit(ProductError(
          error.message,
          categories: currentCategories,
          selectedCategoryId: event.categoryId,
        ));
    }
  }

  Future<void> _onCategoryRequested(
    CategoryRequested event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _productRepository.getCategories();
    switch (result) {
      case Success(:final data):
        final current = state;
        emit(
          switch (current) {
            ProductLoaded(
              :final products,
              :final hasReachedMax,
              :final isLoadingMore,
            ) =>
              ProductLoaded(
                products,
                hasReachedMax: hasReachedMax,
                isLoadingMore: isLoadingMore,
                categories: data,
                selectedCategoryId: current.selectedCategoryId,
              ),
            ProductInitial() => ProductInitial(
                categories: data,
                selectedCategoryId: current.selectedCategoryId,
              ),
            ProductLoading() => ProductLoading(
                categories: data,
                selectedCategoryId: current.selectedCategoryId,
              ),
            ProductEmpty() => ProductEmpty(
                categories: data,
                selectedCategoryId: current.selectedCategoryId,
              ),
            ProductError(:final message) => ProductError(
                message,
                categories: data,
                selectedCategoryId: current.selectedCategoryId,
              ),
          },
        );
      case Error():
        break;
    }
  }

  Future<void> _onProductsLoadMore(
    ProductsLoadMore event,
    Emitter<ProductState> emit,
  ) async {
    final current = state;
    if (current is! ProductLoaded ||
        current.hasReachedMax ||
        current.isLoadingMore ||
        current.selectedCategoryId != null) {
      return;
    }
    emit(
      ProductLoaded(
        current.products,
        hasReachedMax: current.hasReachedMax,
        isLoadingMore: true,
        categories: current.categories,
        selectedCategoryId: current.selectedCategoryId,
      ),
    );
    final result = await _productRepository.getProducts(
      offset: current.products.length,
      categoryId: current.selectedCategoryId,
    );
    switch (result) {
      case Success(:final data):
        final merged = [...current.products, ...data];
        emit(ProductLoaded(
          merged,
          hasReachedMax: data.length < _limit,
          categories: current.categories,
          selectedCategoryId: current.selectedCategoryId,
        ));
      case Error():
        emit(
          ProductLoaded(
            current.products,
            hasReachedMax: current.hasReachedMax,
            categories: current.categories,
            selectedCategoryId: current.selectedCategoryId,
          ),
        );
    }
  }
}
