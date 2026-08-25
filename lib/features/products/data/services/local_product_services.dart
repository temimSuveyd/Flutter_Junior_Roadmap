import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../dtos/product_responce.dart';
import '../mappers/product_mapper.dart';
import '../models/product_model.dart';

abstract class LocalProductServices {
  List<ProductModel> getCachedProducts();
  Future<void> cacheProducts({required List<dynamic> products});
  Future<void> clearProductCache();
}

class LocalProductServicesImpl extends LocalProductServices {

  LocalProductServicesImpl(this._prefs);
  final SharedPreferences _prefs;
  static const String _cacheKey = 'cached_products';

  @override
  Future<void> cacheProducts({required List<dynamic> products}) async {
    await _prefs.setString(_cacheKey, jsonEncode(products));
  }

  List<ProductModel> _mapProducts(List<dynamic> productsList) {
    return productsList
        .map(
          (item) => ProductMapper.toProductModel(
            ProductResponce.fromJson(item as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  @override
  List<ProductModel> getCachedProducts() {
    final cached = _prefs.getString(_cacheKey);
    try {
      final decoded = jsonDecode(cached!) as List<dynamic>;
      return _mapProducts(decoded);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> clearProductCache() async {
    await _prefs.remove(_cacheKey);
  }
}
