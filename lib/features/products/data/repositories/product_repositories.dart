import 'package:juniorflutterroadmap/core/services/network/failure.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:juniorflutterroadmap/features/products/data/services/product_services.dart';

abstract class ProductRepository {
  Future<(Failure? failure, List<ProductModel>? products)> getProducts();
}

class ProductRepositoryImpl extends ProductRepository {
  final ProductServices _productServices;
  ProductRepositoryImpl(this._productServices);

  @override
  Future<(Failure? failure, List<ProductModel>? products)> getProducts() async {
    try {
      final products = await _productServices.getProducts();
      return (null, products);
    } on Failure catch (customFailure) {
      return (customFailure, null);
    } catch (unexpectedError) {
      final systemFailure = Failure(
        "A system error occurred: ${unexpectedError.toString()}",
      );
      return (systemFailure, null);
    }
  }
}