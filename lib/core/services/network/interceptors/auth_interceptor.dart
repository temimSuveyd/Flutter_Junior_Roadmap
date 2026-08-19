import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage.dart';

import '../failure.dart';

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
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    String mesaj = "An unexpected error occurred.";
    if (err.response?.statusCode == 401) {
      log('Dio Error:${err.response?.statusCode} - clearing token');
      await _secureStorage.deleteToken();
    }
    mesaj = err.response?.data['error_message'] ?? "Server error.";
    return handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: Failure(mesaj, statusCode: err.response?.statusCode),
        
      ),
    );
  }
}
