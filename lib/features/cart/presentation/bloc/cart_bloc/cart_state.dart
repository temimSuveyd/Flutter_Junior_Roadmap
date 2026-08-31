part of 'cart_bloc.dart';

@immutable
sealed class CartState {
  const CartState();
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartEmpty extends CartState {
  const CartEmpty();
}

final class CartLoaded extends CartState {
  const CartLoaded({
    required this.items,
    required this.total,
  });

  final List<CartItemModel> items;
  final double total;

  int get itemCount => items.length;
}

final class CartProcessing extends CartState {
  const CartProcessing({required this.total});
  final double total;
}

final class CartPaymentSuccess extends CartState {
  const CartPaymentSuccess();
}
