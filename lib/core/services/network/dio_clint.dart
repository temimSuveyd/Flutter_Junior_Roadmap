import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage.dart';
import 'api_endpoints.dart';
import 'failure.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(_secureStorage),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  final SecureStorage _secureStorage;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      log(e.toString());
      throw _handleError(e);
    }
  }

  Failure _handleError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Internet connection timed out.',
      DioExceptionType.badResponse =>
        'Request failed${statusCode != null ? ' ($statusCode)' : ''}.',
      DioExceptionType.connectionError =>
        'No internet connection. Check your network.',
      _ => 'An unexpected error has occurred.',
    };
    return Failure(message, statusCode: statusCode);
  }
}
