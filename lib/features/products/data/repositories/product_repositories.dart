import '../../../../core/errors/result.dart';
import '../../../../core/services/network/network_info.dart';
import '../dtos/product_responce.dart';
import '../mappers/product_mapper.dart';
import '../models/product_model.dart';
import '../services/local_product_services.dart';
import '../services/remote_product_services.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>>> getProducts();
}

class ProductRepositoryImpl extends ProductRepository with NetworkInfo {
  final RemoteProductServices _remoteProductServices;
  final LocalProductServices _localProductServices;
  ProductRepositoryImpl(
    this._localProductServices,
    this._remoteProductServices,
  );

  @override
  Future<Result<List<ProductModel>>> getProducts() async {
    return runCatching(() async {
      if (await isOnline) {
        final remoteProducts = await _remoteProductServices.getProducts();
        await _localProductServices.clearProductCache();
        await _localProductServices.cacheProducts(products: remoteProducts);
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
}
