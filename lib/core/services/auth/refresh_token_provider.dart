abstract class RefreshTokenProvider {
  static const isRefreshRequestKey = 'is_refresh_request';

  Future<String?> refreshUserToken(String refreshToken);
}