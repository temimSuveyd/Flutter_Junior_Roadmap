import 'package:hive/hive.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_hive_model.dart';

abstract class FavoriteLocalService {
  Set<int> getFavoriteIds();
  List<ProductHiveModel> getFavorites();
  bool isFavorite(int productId);
  Future<void> addFavorite(ProductHiveModel product);
  Future<void> removeFavorite(int productId);
}

class FavoriteLocalServiceImpl extends FavoriteLocalService {
  FavoriteLocalServiceImpl(this._box);

  final Box _box;
  static const String _favoritesKey = 'favorite_products';

  @override
  Set<int> getFavoriteIds() {
    try {
      final products = _box.get(_favoritesKey) as List<dynamic>?;
      if (products == null) return {};
      return products
          .cast<ProductHiveModel>()
          .map((p) => p.id)
          .toSet();
    } catch (_) {
      return {};
    }
  }

  @override
  List<ProductHiveModel> getFavorites() {
    try {
      final products = _box.get(_favoritesKey) as List<dynamic>?;
      if (products == null) return [];
      return products.cast<ProductHiveModel>();
    } catch (_) {
      return [];
    }
  }

  @override
  bool isFavorite(int productId) {
    return getFavoriteIds().contains(productId);
  }

  @override
  Future<void> addFavorite(ProductHiveModel product) async {
    final current = getFavorites();
    if (current.any((p) => p.id == product.id)) return;
    current.add(product);
    await _box.put(_favoritesKey, current);
  }

  @override
  Future<void> removeFavorite(int productId) async {
    final current = getFavorites();
    current.removeWhere((p) => p.id == productId);
    await _box.put(_favoritesKey, current);
  }
}
