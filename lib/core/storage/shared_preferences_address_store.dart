import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'address_data.dart';
import 'address_store.dart';

class SharedPreferencesAddressStore implements AddressStore {
  SharedPreferencesAddressStore(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'user_address';

  @override
  Future<Address?> read() async {
    final raw = _prefs.getString(_key);
    if (raw == null) {
      return null;
    }
    return Address.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(Address address) async {
    await _prefs.setString(_key, jsonEncode(address.toJson()));
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
