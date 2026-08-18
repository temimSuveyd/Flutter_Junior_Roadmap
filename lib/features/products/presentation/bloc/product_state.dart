part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}
final class ProductLoading extends ProductState {}
final class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
final class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}