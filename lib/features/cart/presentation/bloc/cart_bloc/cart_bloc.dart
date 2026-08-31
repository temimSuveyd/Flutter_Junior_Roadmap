import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:juniorflutterroadmap/features/cart/data/models/cart_item_model.dart';
import 'package:juniorflutterroadmap/features/cart/data/repositories/cart_repository.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._repository) : super(const CartInitial()) {
    on<CartItemsLoaded>(_onCartItemsLoaded);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartQuantityIncreased>(_onQuantityIncreased);
    on<CartQuantityDecreased>(_onQuantityDecreased);
    on<CartCleared>(_onCartCleared);
    on<CheckoutRequested>(
      _onCheckoutRequested,
      // Ödeme sırasında birden fazla kez tetiklenmesini engelle
      transformer: droppable(),
    );
  }

  final CartRepository _repository;

  void _emitUpdated(Emitter<CartState> emit) {
    final items = _repository.getCartItems();
    final total = _repository.getCartTotal();
    if (items.isEmpty) {
      emit(const CartEmpty());
    } else {
      emit(CartLoaded(items: items, total: total));
    }
  }

  Future<void> _onCartItemsLoaded(
    CartItemsLoaded event,
    Emitter<CartState> emit,
  ) async {
    _emitUpdated(emit);
  }

  Future<void> _onCartItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    await _repository.addToCart(event.product);
    _emitUpdated(emit);
  }

  Future<void> _onCartItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    await _repository.removeFromCart(event.productId);
    _emitUpdated(emit);
  }

  Future<void> _onQuantityIncreased(
    CartQuantityIncreased event,
    Emitter<CartState> emit,
  ) async {
    final items = _repository.getCartItems();
    final item = items.firstWhere((i) => i.id == event.productId);
    await _repository.updateQuantity(event.productId, item.quantity + 1);
    _emitUpdated(emit);
  }

  Future<void> _onQuantityDecreased(
    CartQuantityDecreased event,
    Emitter<CartState> emit,
  ) async {
    final items = _repository.getCartItems();
    final item = items.firstWhere((i) => i.id == event.productId);
    if (item.quantity > 1) {
      await _repository.updateQuantity(event.productId, item.quantity - 1);
    } else {
      await _repository.removeFromCart(event.productId);
    }
    _emitUpdated(emit);
  }

  Future<void> _onCartCleared(
    CartCleared event,
    Emitter<CartState> emit,
  ) async {
    await _repository.clearCart();
    emit(const CartEmpty());
  }

  Future<void> _onCheckoutRequested(
    CheckoutRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(CartProcessing(total: _repository.getCartTotal()));
    // Fake 1s payment delay
    await Future.delayed(const Duration(seconds: 1));
    await _repository.clearCart();
    emit(const CartPaymentSuccess());
  }
}
