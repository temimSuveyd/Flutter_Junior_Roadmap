import 'package:juniorflutterroadmap/features/cart/data/models/cart_item_model.dart';
import 'package:juniorflutterroadmap/features/cart/data/services/cart_local_service.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';

abstract class CartRepository {
  List<CartItemModel> getCartItems();
  double getCartTotal();
  Future<void> addToCart(ProductModel product);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();
}

class CartRepositoryImpl extends CartRepository {
  CartRepositoryImpl(this._localService);

  final CartLocalService _localService;

  @override
  List<CartItemModel> getCartItems() => _localService.getCartItems();

  @override
  double getCartTotal() {
    return _localService
        .getCartItems()
        .fold<double>(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Future<void> addToCart(ProductModel product) async {
    final items = _localService.getCartItems();
    final existingIndex = items.indexWhere((i) => i.id == product.id);

    if (existingIndex != -1) {
      await _localService.updateQuantity(
        product.id,
        items[existingIndex].quantity + 1,
      );
    } else {
      await _localService.addItem(
        CartItemModel.fromProduct(product),
      );
    }
  }

  @override
  Future<void> removeFromCart(int productId) =>
      _localService.removeItem(productId);

  @override
  Future<void> updateQuantity(int productId, int quantity) =>
      _localService.updateQuantity(productId, quantity);

  @override
  Future<void> clearCart() => _localService.clearCart();
}
