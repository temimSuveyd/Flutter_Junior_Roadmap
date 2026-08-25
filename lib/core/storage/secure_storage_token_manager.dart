import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_token_manager.dart';

class SecureStorageTokenManager implements AuthTokenManager {
  SecureStorageTokenManager(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  // In-memory cache so interceptors can read tokens synchronously.
  String? _accessToken;
  String? _refreshToken;

  @override
  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  @override
  String? getAccessTokenSync() => _accessToken;

  @override
  String? getRefreshTokenSync() => _refreshToken;

  @override
  Future<void> load() async {
    _accessToken = await _storage.read(key: _accessTokenKey);
    _refreshToken = await _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
    if (refreshToken != null) {
      _refreshToken = refreshToken;
    }
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
