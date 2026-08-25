import 'package:dio/dio.dart';

import 'package:juniorflutterroadmap/core/services/auth/refresh_token_provider.dart';
import 'package:juniorflutterroadmap/core/services/network/api_endpoints.dart';

/// Decouples the circular dependency between DioClient and AuthService;
/// the token-refresh capability is extracted from AuthService as an
/// independent provider. DioClient uses it in its own lifecycle
/// without needing AuthService.
class TokenRefresher implements RefreshTokenProvider {
  const TokenRefresher();

  @override
  Future<String?> refreshUserToken(String refreshToken, Dio dio) async {
    final response = await dio.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
      options: Options(extra: {RefreshTokenProvider.isRefreshRequestKey: true}),
    );
    final data = response.data as Map<String, dynamic>;
    return data['access_token'] as String?;
  }
}
