import 'package:hive/hive.dart';
import '../dtos/product_response.dart';
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
    final models = products
        .map(
          (item) => ProductModel.fromResponse(
            ProductResponse.fromJson(item as Map<String, dynamic>),
          ),
        )
        .toList();
    await _box.put(_cacheKey, models);
  }

  @override
  List<ProductModel> getCachedProducts() {
    try {
      final cached = _box.get(_cacheKey) as List<dynamic>?;
      if (cached == null) return [];
      return cached.cast<ProductModel>();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> clearProductCache() async {
    await _box.delete(_cacheKey);
  }
}
