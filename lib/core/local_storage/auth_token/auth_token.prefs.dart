import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';

class AuthTokenPrefs {
  static const _authTokenKey = 'auth_token';

  static String? get() {
    return SharedPrefsHelper.prefs.getString(_authTokenKey);
  }

  static Future<void> set(String token) async {
    await SharedPrefsHelper.prefs.setString(_authTokenKey, token);
  }

  static Future<void> remove() async {
    await SharedPrefsHelper.prefs.remove(_authTokenKey);
  }
}
