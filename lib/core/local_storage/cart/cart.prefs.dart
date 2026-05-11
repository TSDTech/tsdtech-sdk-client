import 'dart:convert';

import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/models/cart/cart_item.model.dart';

class CartPrefs {
  static const _key = 'cart_data';
  // TTL in milliseconds (2 hours)
  static const int _ttlMs = 1000 * 60 * 60 * 2;

  /// Returns the saved raw items list (each item is a Map with 'service' and 'quantity')
  /// or null if none or expired.
  static List<CartItem>? get() {
    final raw = SharedPrefsHelper.prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final savedAt = (decoded['savedAt'] as int?) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - savedAt > _ttlMs) {
        // expired
        SharedPrefsHelper.prefs.remove(_key);
        return null;
      }
      final items = decoded['items'] as List<dynamic>?;
      if (items == null) return null;
      return items.map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (_) {
      return null;
    }
  }

  /// Save the raw items list with current timestamp.
  static Future<void> set(List<CartItem> items) async {
    final payload = {
      'savedAt': DateTime.now().millisecondsSinceEpoch,
      'items': items.map((i) => i.toJson()).toList()
    };
    await SharedPrefsHelper.prefs.setString(_key, jsonEncode(payload));
  }

  static Future<void> remove() async {
    await SharedPrefsHelper.prefs.remove(_key);
  }
}
