import 'package:dio/dio.dart';

class AutoRetryInterceptor extends Interceptor {
  AutoRetryInterceptor({
    required Dio dio,
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 1),
  }) : _dio = dio;

  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  static const String _retryCountKey = 'auto_retry_count';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra[_retryCountKey] as int?) ?? 0;

    if (!_isRetryable(err) || attempt >= maxRetries) {
      return handler.next(err);
    }

    err.requestOptions.extra[_retryCountKey] = attempt + 1;
    await Future<void>.delayed(retryDelay);

    try {
      final response = await _dio.fetch<dynamic>(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  bool _isRetryable(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => true,
      _ => false,
    };
  }
}
