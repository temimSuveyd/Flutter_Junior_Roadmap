
import '../../../../core/errors/result.dart';
import '../models/product_model.dart';
import '../services/product_services.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>>> getProducts();
}

class ProductRepositoryImpl extends ProductRepository {
  final ProductServices _productServices;
  ProductRepositoryImpl(this._productServices);

  @override
  Future<Result<List<ProductModel>>> getProducts() {
    return _productServices.getProducts().toResult();
  }
}
