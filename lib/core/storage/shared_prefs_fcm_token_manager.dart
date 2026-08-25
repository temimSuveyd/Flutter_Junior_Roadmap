import 'package:shared_preferences/shared_preferences.dart';

import 'fcm_token_manager.dart';

/// SharedPreferences-backed implementation that stores the FCM token locally.
class SharedPrefsFcmTokenManager implements FcmTokenManager {
  SharedPrefsFcmTokenManager(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'fcm_token';

  @override
  Future<String?> getToken() async => _prefs.getString(_key);

  @override
  Future<void> saveToken(String token) async =>
      await _prefs.setString(_key, token);

  @override
  Future<void> clearToken() async => await _prefs.remove(_key);
}
