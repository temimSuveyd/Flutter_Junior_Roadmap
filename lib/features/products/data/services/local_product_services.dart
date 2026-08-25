import 'package:hive/hive.dart';
import '../dtos/product_response.dart';
import '../models/product_hive_model.dart';
import '../models/product_model.dart';

abstract class LocalProductServices {
  List<ProductModel> getCachedProducts();
  Future<void> cacheProducts({required List<dynamic> products});
  Future<void> clearProductCache();
}

class LocalProductServicesImpl extends LocalProductServices {
  LocalProductServicesImpl(this._box);

  final Box _box;
  static const String _cacheKey = 'cached_products';

  @override
  Future<void> cacheProducts({required List<dynamic> products}) async {
    final hiveModels = products
        .map(
          (item) => ProductHiveModel.fromResponse(
            ProductResponse.fromJson(item as Map<String, dynamic>),
          ),
        )
        .toList();
    await _box.put(_cacheKey, hiveModels);
  }

  List<ProductModel> _mapProducts(List<ProductHiveModel> productsList) {
    return productsList
        .map(
          (item) => ProductModel(
            image: item.image,
            title: item.title,
            description: item.description,
            price: item.price,
            id: item.id,
            category: item.category,
          ),
        )
        .toList();
  }

  @override
  List<ProductModel> getCachedProducts() {
    try {
      final cached = _box.get(_cacheKey) as List<dynamic>?;
      if (cached == null) return [];
      return _mapProducts(cached.cast<ProductHiveModel>());
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> clearProductCache() async {
    await _box.delete(_cacheKey);
  }
}
