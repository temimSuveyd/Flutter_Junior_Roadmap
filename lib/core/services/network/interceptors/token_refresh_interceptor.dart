import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/services/auth/refresh_token_provider.dart';
import 'package:juniorflutterroadmap/core/storage/auth_token_manager.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required AuthTokenManager tokenManager,
    required RefreshTokenProvider Function() refreshTokenProvider,
    required Dio dio,
  })  : _tokenManager = tokenManager,
        _refreshTokenProvider = refreshTokenProvider,
        _dio = dio {
    _refreshDio = Dio(_dio.options);
  }

  static const _refreshedKey = 'token_refreshed';

  final AuthTokenManager _tokenManager;
  final RefreshTokenProvider Function() _refreshTokenProvider;
  final Dio _dio;
  late final Dio _refreshDio;

  Future<String?>? _inFlightRefresh;

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

    final newAccessToken = await _getNewAccessToken();
    if (newAccessToken == null) {
      await _tokenManager.clearTokens();
      return handler.next(err);
    }

    err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
    err.requestOptions.extra[_refreshedKey] = true;

    try {
      final response = await _refreshDio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  Future<String?> _getNewAccessToken() {
    final inFlight = _inFlightRefresh;
    if (inFlight != null) {
      return inFlight;
    }
    final future = _refresh().whenComplete(() {
      _inFlightRefresh = null;
    });
    _inFlightRefresh = future;
    return future;
  }

  Future<String?> _refresh() async {
    final refreshToken = await _tokenManager.getRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    try {
      final newAccessToken = await _refreshTokenProvider().refreshUserToken(
        refreshToken,
        _refreshDio,
      );
      if (newAccessToken == null) {
        return null;
      }
      await _tokenManager.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );
      return newAccessToken;
    } catch (_) {
      return null;
    }
  }
}