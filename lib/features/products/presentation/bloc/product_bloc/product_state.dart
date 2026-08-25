part of 'product_bloc.dart';

@immutable
sealed class ProductState {
  const ProductState({
    this.categories = const [],
    this.selectedCategoryId,
  });
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
}

final class ProductInitial extends ProductState {
  const ProductInitial({super.categories, super.selectedCategoryId});
}
final class ProductLoading extends ProductState {
  const ProductLoading({super.categories, super.selectedCategoryId});
}
final class ProductError extends ProductState {
  const ProductError(this.message, {super.categories, super.selectedCategoryId});
  final String message;
}
final class ProductEmpty extends ProductState {
  const ProductEmpty({super.categories, super.selectedCategoryId});
}
final class ProductLoaded extends ProductState {

  const ProductLoaded(
    this.products, {
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    super.categories,
    super.selectedCategoryId,
  });
  final List<ProductModel> products;
  final bool hasReachedMax;
  final bool isLoadingMore;
}
