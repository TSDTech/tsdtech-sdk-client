import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/core/local_storage/administrator/administrator_id.prefs.dart';
import 'package:voucherize/core/services/intra-api/md-administrators/administrators_service.dart';

/// Attempts to resolve the application's administrator by the configured
/// `Constants.fullDomain`. If resolved, persists both the resolved fullDomain
/// and the administrator id into shared preferences.
///
/// Returns `true` when an administrator id was successfully cached, `false`
/// otherwise. This function never throws; callers can treat failures as
/// non-fatal and optionally handle the `false` result.
Future<bool> resolveAndCacheAdministrator() async {
  try {
    final fullDomain = Constants.fullDomain;
    if (fullDomain.isEmpty) return false;

    try {
      final adminSvc = AdministratorsService();
      final result = await adminSvc.getByFullDomain(fullDomain: fullDomain);
      if (result.isSuccess && result.value != null) {
        await AdministratorIdPrefs.set(result.value!.id);
        return true;
      }
    } catch (_) {
      // ignore inner errors
    }
  } catch (_) {
    // ignore outer errors
  }

  return false;
}
