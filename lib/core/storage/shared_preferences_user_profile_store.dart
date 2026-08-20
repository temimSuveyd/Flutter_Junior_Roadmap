import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'user_profile_data.dart';
import 'user_profile_store.dart';

class SharedPreferencesUserProfileStore implements UserProfileStore {
  SharedPreferencesUserProfileStore(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'user_profile';

  @override
  Future<UserProfileData?> read() async {
    final raw = _prefs.getString(_key);
    if (raw == null) {
      return null;
    }
    return UserProfileData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(UserProfileData data) async {
    await _prefs.setString(_key, jsonEncode(data.toJson()));
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}