import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorage _secureStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      log('Dio Error:${err.response?.statusCode}');
    }
    return handler.next(err);
  }
}
