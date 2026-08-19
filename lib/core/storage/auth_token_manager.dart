abstract class AuthTokenManager {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  });
  Future<void> clearTokens();
}