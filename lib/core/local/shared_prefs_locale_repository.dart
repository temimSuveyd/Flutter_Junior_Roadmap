import 'package:shared_preferences/shared_preferences.dart';

/// Interface for saving and retrieving the locale from local storage.
abstract class LocaleRepository {
  Future<String?> getLocaleCode();
  Future<void> saveLocaleCode(String code);
}

/// Implementation backed by SharedPreferences.
class SharedPrefsLocaleRepository implements LocaleRepository {
  SharedPrefsLocaleRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'app_locale';

  @override
  Future<String?> getLocaleCode() async {
    return _prefs.getString(_key);
  }

  @override
  Future<void> saveLocaleCode(String code) async {
    await _prefs.setString(_key, code);
  }
}
