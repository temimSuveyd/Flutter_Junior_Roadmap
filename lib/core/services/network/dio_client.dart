import 'package:dio/dio.dart';
import '../../storage/auth_token_manager.dart';
import '../auth/refresh_token_provider.dart';
import 'api_endpoints.dart';
import 'failure.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/token_refresh_interceptor.dart';

class DioClient {

  DioClient(
    this._tokenManager, 
    {
    AuthTokenManager? tokenManager,
    RefreshTokenProvider Function()? refreshTokenProvider,
  }) {
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

    final interceptors = <Interceptor>[
      AuthInterceptor(_tokenManager),
      ErrorInterceptor(),
      AutoRetryInterceptor(dio: _dio),
    ];

    if (tokenManager != null && refreshTokenProvider != null) {
      interceptors.insert(
        2,
        TokenRefreshInterceptor(
          tokenManager: tokenManager,
          refreshTokenProvider: refreshTokenProvider,
          dio: _dio,
        ),
      );
    }

    _dio.interceptors.addAll(interceptors);
  }
  late final Dio _dio;

  final AuthTokenManager _tokenManager;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } on DioException catch (e) {
      throw _toFailure(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } on DioException catch (e) {
      throw _toFailure(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } on DioException catch (e) {
      throw _toFailure(e);
    }
  }

  Failure _toFailure(DioException error) {
    final failure = error.error;
    if (failure is Failure) {
      return failure;
    }
    final serverMessage = extractServerErrorMessage(error.response?.data);
    return Failure(
      serverMessage.isNotEmpty
          ? serverMessage
          : 'An unexpected error has occurred.',
      statusCode: error.response?.statusCode,
    );
  }
}