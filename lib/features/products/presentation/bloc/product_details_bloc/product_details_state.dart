part of 'product_details_bloc.dart';

@immutable
sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsLoaded extends ProductDetailsState {
  ProductDetailsLoaded(this.product);
  final ProductModel product;
}

final class ProductDetailsError extends ProductDetailsState {
  ProductDetailsError(this.message);
  final String message;
}
