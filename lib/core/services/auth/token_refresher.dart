import 'package:dio/dio.dart';

import 'package:juniorflutterroadmap/core/services/auth/refresh_token_provider.dart';
import 'package:juniorflutterroadmap/core/services/network/api_endpoints.dart';

/// DioClient ile AuthService arasındaki döngüsel bağımlılığı kırmak için
/// token yenileme yeteneği AuthService'ten ayrıştırılmış bağımsız
/// bir sağlayıcıdır. DioClient, kendi yaşam döngüsünde AuthService'e
/// ihtiyaç duymadan bunu kullanır.
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
