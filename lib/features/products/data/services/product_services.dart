import '../../../../core/services/network/api_endpoints.dart';
import '../../../../core/services/network/dio_clint.dart';
import '../dtos/product_responce.dart';
import '../mappers/product_mapper.dart';
import '../models/product_model.dart';

abstract class ProductServices {
  Future<List<ProductModel>> getProducts();
}

class ProductServicesImpl extends ProductServices {
  final DioClient _dioClient;
  ProductServicesImpl(this._dioClient);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await _dioClient.get(ApiEndpoints.getProducts);
    final List<dynamic> rawData = (response.data as List);

    return rawData
        .map(
          (item) => ProductMapper.toProductModel(
            ProductResponce.fromJson(item as Map<String, dynamic>),
          ),
        )
        .toList();
  }
}
