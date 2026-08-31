part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class CartItemsLoaded extends CartEvent {}

final class CartItemAdded extends CartEvent {
  CartItemAdded(this.product);
  final ProductModel product;
}

final class CartItemRemoved extends CartEvent {
  CartItemRemoved(this.productId);
  final int productId;
}

final class CartQuantityIncreased extends CartEvent {
  CartQuantityIncreased(this.productId);
  final int productId;
}

final class CartQuantityDecreased extends CartEvent {
  CartQuantityDecreased(this.productId);
  final int productId;
}

final class CartCleared extends CartEvent {}

final class CheckoutRequested extends CartEvent {}
