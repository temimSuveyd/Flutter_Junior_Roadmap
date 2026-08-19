import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/services/auth/refresh_token_provider.dart';
import 'package:juniorflutterroadmap/core/storage/auth_token_manager.dart';

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required AuthTokenManager tokenManager,
    required RefreshTokenProvider Function() refreshTokenProvider,
    required Dio dio,
  })  : _tokenManager = tokenManager,
        _refreshTokenProvider = refreshTokenProvider,
        _dio = dio;

  static const _refreshedKey = 'token_refreshed';

  final AuthTokenManager _tokenManager;
  final RefreshTokenProvider Function() _refreshTokenProvider;
  final Dio _dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isRefreshRequest =
        err.requestOptions.extra[RefreshTokenProvider.isRefreshRequestKey] ==
            true;
    final alreadyRefreshed = err.requestOptions.extra[_refreshedKey] == true;

    if (err.response?.statusCode != 401 ||
        isRefreshRequest ||
        alreadyRefreshed) {
      return handler.next(err);
    }

    final refreshToken = await _tokenManager.getRefreshToken();
    if (refreshToken == null) {
      await _tokenManager.clearTokens();
      return handler.next(err);
    }

    String? newAccessToken;
    try {
      newAccessToken = await _refreshTokenProvider().refreshUserToken(
        refreshToken,
      );
    } catch (_) {
      newAccessToken = null;
    }

    if (newAccessToken == null) {
      await _tokenManager.clearTokens();
      return handler.next(err);
    }

    await _tokenManager.saveTokens(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
    );
    err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
    err.requestOptions.extra[_refreshedKey] = true;

    try {
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }
}