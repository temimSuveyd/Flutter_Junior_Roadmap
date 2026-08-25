abstract class AuthTokenManager {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();

  /// Synchronous access backed by an in-memory cache (populated by [load]
  /// and [saveTokens]). Intended for hot paths such as network interceptors
  /// so a request header can be added without awaiting disk I/O.
  String? getAccessTokenSync();

  /// Synchronous access to the refresh token from the in-memory cache.
  String? getRefreshTokenSync();

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  });
  Future<void> clearTokens();

  /// Hydrates the in-memory cache from persistent storage. Call once at startup.
  Future<void> load();
}
