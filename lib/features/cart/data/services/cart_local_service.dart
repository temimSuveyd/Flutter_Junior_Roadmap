import 'package:hive/hive.dart';
import 'package:juniorflutterroadmap/features/cart/data/models/cart_item_model.dart';

abstract class CartLocalService {
  List<CartItemModel> getCartItems();
  Future<void> addItem(CartItemModel item);
  Future<void> removeItem(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();
}

class CartLocalServiceImpl extends CartLocalService {
  CartLocalServiceImpl(this._box);

  final Box _box;
  static const String _cartKey = 'cart_items';

  @override
  List<CartItemModel> getCartItems() {
    try {
      final items = _box.get(_cartKey) as List<dynamic>?;
      if (items == null) return [];
      return items.cast<CartItemModel>();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addItem(CartItemModel item) async {
    final current = getCartItems();
    final index = current.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      current[index] = current[index].copyWith(
        quantity: current[index].quantity + 1,
      );
    } else {
      current.add(item);
    }
    await _box.put(_cartKey, current);
  }

  @override
  Future<void> removeItem(int productId) async {
    final current = getCartItems();
    current.removeWhere((i) => i.id == productId);
    await _box.put(_cartKey, current);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final current = getCartItems();
    final index = current.indexWhere((i) => i.id == productId);
    if (index == -1) return;
    if (quantity <= 0) {
      current.removeAt(index);
    } else {
      current[index] = current[index].copyWith(quantity: quantity);
    }
    await _box.put(_cartKey, current);
  }

  @override
  Future<void> clearCart() async {
    await _box.delete(_cartKey);
  }
}
