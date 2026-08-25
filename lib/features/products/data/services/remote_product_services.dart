import '../../../../core/services/network/api_endpoints.dart';
import '../../../../core/services/network/dio_client.dart';

abstract class RemoteProductServices {
  Future<List<dynamic>> getProducts({int? offset, int? categoryId});
  Future<List<dynamic>> getCategories();
  Future<Map<String, dynamic>> getProductById(int id);
  Future<List<dynamic>> searchProducts(String query);
}

class RemoteProductServicesImpl extends RemoteProductServices {
  final DioClient _dioClient;
  RemoteProductServicesImpl(this._dioClient);

  @override
  Future<List<dynamic>> getProducts({int? offset, int? categoryId}) async {
    final queryParameters = <String, dynamic>{};
    if (offset != null) queryParameters['offset'] = offset;
    queryParameters['limit'] = 20;
    if (categoryId != null) queryParameters['categoryId'] = categoryId;
    final response = await _dioClient.get(
      ApiEndpoints.getProducts,
      queryParameters: queryParameters,
    );
    return response.data as List<dynamic>;
  }

  @override
  Future<List<dynamic>> getCategories() async {
    final response = await _dioClient.get(ApiEndpoints.getCategories);
    return response.data as List<dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getProductById(int id) async {
    final response =
        await _dioClient.get(ApiEndpoints.getProductById(id));
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> searchProducts(String query) async {
    final response = await _dioClient.get(
      ApiEndpoints.getProducts,
      queryParameters: {'title': query},
    );
    return response.data as List<dynamic>;
  }
}
