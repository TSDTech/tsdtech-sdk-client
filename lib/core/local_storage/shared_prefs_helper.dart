import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _authTokenKey = 'auth_token';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isInitialized => _prefs != null;

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> setString(String key, String value) async {
    if (_prefs == null) return false;
    return _prefs!.setString(key, value);
  }

  static Future<bool> remove(String key) async {
    if (_prefs == null) return false;
    return _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    if (_prefs == null) return false;
    return _prefs!.clear();
  }

  static String? get authToken {
    return getString(_authTokenKey);
  }

  static Future<bool> setAuthToken(String token) async {
    return setString(_authTokenKey, token);
  }

  static Future<bool> clearAuthToken() async {
    return remove(_authTokenKey);
  }
}
