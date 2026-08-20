import '../../../../core/services/network/api_endpoints.dart';
import '../../../../core/services/network/dio_clint.dart';
import '../dtos/product_responce.dart';
import '../mappers/product_mapper.dart';
import '../models/product_model.dart';

abstract class RemoteProductServices {
  Future<List<dynamic>> getProducts();
}

class RemoteProductServicesImpl extends RemoteProductServices {
  final DioClient _dioClient;
  RemoteProductServicesImpl(this._dioClient);

  @override
  Future<List<dynamic>> getProducts() async {
    final response = await _dioClient.get(ApiEndpoints.getProducts);
    final List<dynamic> productsList = response.data as List<dynamic>;

    return productsList;
  }
}
