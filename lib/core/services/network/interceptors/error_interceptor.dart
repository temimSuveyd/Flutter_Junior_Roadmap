import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/services/network/failure.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.error is Failure) {
      return handler.next(err);
    }

    final statusCode = err.response?.statusCode;
    final failure = Failure(_message(err), statusCode: statusCode);
    return handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
      ),
    );
  }

  String _message(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final serverMessage = data['error_message'];
      if (serverMessage is String && serverMessage.isNotEmpty) {
        return serverMessage;
      }
    }

    final statusCode = error.response?.statusCode;
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Internet connection timed out.',
      DioExceptionType.badResponse =>
        'Request failed${statusCode != null ? ' ($statusCode)' : ''}.',
      DioExceptionType.connectionError =>
        'No internet connection. Check your network.',
      DioExceptionType.cancel => 'Request was cancelled.',
      _ => 'An unexpected error has occurred.',
    };
  }
}