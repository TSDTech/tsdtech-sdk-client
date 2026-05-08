import 'package:voucherize/core/local_storage/shared_prefs_helper.dart';

class AdministratorIdPrefs {
  static const _key = 'administrator_id';

  static String? get() {
    return SharedPrefsHelper.prefs.getString(_key);
  }

  static Future<void> set(String id) async {
    await SharedPrefsHelper.prefs.setString(_key, id);
  }

  static Future<void> remove() async {
    await SharedPrefsHelper.prefs.remove(_key);
  }
}
