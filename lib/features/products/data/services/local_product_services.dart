import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../dtos/product_responce.dart';
import '../mappers/product_mapper.dart';
import '../models/product_model.dart';

abstract class LocalProductServices {
  List<ProductModel> getLoclProduct();
  Future<void> cashProducts({required List<dynamic> products});
}

class LocalProductServicesImpl extends LocalProductServices {
  final SharedPreferences _prefs;
  static const String _cacheKey = 'cached_products';

  LocalProductServicesImpl(this._prefs);

  @override
  Future<void> cashProducts({required List<dynamic> products}) async {
    await _prefs.setString(_cacheKey, jsonEncode(products));
  }

  // @override
  // Future<List<ProductModel>> cashProducts({required List<ProductModel> products}) async {

  // }

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
  List<ProductModel> getLoclProduct() {
    final cached = _prefs.getString(_cacheKey);
    try {
      final decoded = jsonDecode(cached!) as List<dynamic>;
      return _mapProducts(decoded);
    } catch (_) {
      return [];
    }
  }
}
