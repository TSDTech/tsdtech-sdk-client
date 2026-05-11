import 'dart:convert';

import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/models/auth/client-user-token-data.model.dart';

class ClientUserTokenDataPrefs {
  static const _key = 'client_user_token_data';

  static ClientUserTokenData? get() {
    final raw = SharedPrefsHelper.prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return ClientUserTokenData.fromJson(_decode(raw));
    } catch (_) {
      return null;
    }
  }

  static Future<void> set(ClientUserTokenData? data) async {
    if (data == null) {
      await SharedPrefsHelper.prefs.remove(_key);
      return;
    }
    await SharedPrefsHelper.prefs.setString(_key, _encode(data.toJson()));
  }

  static Map<String, dynamic> _decode(String raw) => Map<String, dynamic>.from(jsonDecode(raw) as Map);
  static String _encode(Map<String, dynamic> json) => jsonEncode(json);
}
