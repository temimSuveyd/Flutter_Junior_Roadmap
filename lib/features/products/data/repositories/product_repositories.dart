import '../../../../core/errors/result.dart';
import '../../../../core/services/network/network_info.dart';
import '../dtos/product_response.dart';
import '../mappers/product_mapper.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/local_product_services.dart';
import '../services/remote_product_services.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>>> getProducts({
    int? offset,
    int? categoryId,
  });
  Future<Result<List<CategoryModel>>> getCategories();
  Future<Result<List<ProductModel>>> getProductsByCategory(int categoryId);
  Future<Result<ProductModel>> getProductById(int id);
  Future<Result<List<ProductModel>>> searchProducts(String query);
}

class ProductRepositoryImpl extends ProductRepository with NetworkInfo {
  ProductRepositoryImpl(
    this._localProductServices,
    this._remoteProductServices,
  );
  final RemoteProductServices _remoteProductServices;
  final LocalProductServices _localProductServices;

  @override
  Future<Result<List<ProductModel>>> getProducts({
    int? offset,
    int? categoryId,
  }) async {
    return runCatching(() async {
      if (await isOnline) {
        final remoteProducts = await _remoteProductServices.getProducts(
          offset: offset,
          categoryId: categoryId,
        );

        if (offset == null && categoryId == null) {
          await _localProductServices.clearProductCache();
          await _localProductServices.cacheProducts(products: remoteProducts);
        }
        return remoteProducts
            .map(
              (item) => ProductMapper.toProductModel(
                ProductResponce.fromJson(item as Map<String, dynamic>),
              ),
            )
            .toList();
      }
      final localProducts = _localProductServices.getCachedProducts();
      return localProducts;
    });
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    return runCatching(() async {
      final remoteCategories = await _remoteProductServices.getCategories();
      return remoteCategories
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Result<List<ProductModel>>> getProductsByCategory(int categoryId) {
    return runCatching(() async {
      final remoteProducts =
          await _remoteProductServices.getProductsByCategory(categoryId);
      final products = <ProductModel>[];
      for (final item in remoteProducts) {
        products.add(
          ProductMapper.toProductModel(
            ProductResponce.fromJson(item as Map<String, dynamic>),
          ),
        );
      }
      return products;
    });
  }

  @override
  Future<Result<ProductModel>> getProductById(int id) async {
    return runCatching(() async {
      final data = await _remoteProductServices.getProductById(id);
      return ProductMapper.toProductModel(ProductResponce.fromJson(data));
    });
  }

  @override
  Future<Result<List<ProductModel>>> searchProducts(String query) async {
    return runCatching(() async {
      final remoteProducts = await _remoteProductServices.searchProducts(query);
      return remoteProducts
          .map(
            (item) => ProductMapper.toProductModel(
              ProductResponce.fromJson(item as Map<String, dynamic>),
            ),
          )
          .toList();
    });
  }
}
