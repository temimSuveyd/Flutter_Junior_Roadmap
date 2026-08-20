import 'package:dio/dio.dart';
import '../../../storage/auth_token_manager.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final AuthTokenManager _secureStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await _secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
