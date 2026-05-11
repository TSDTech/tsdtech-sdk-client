import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';

class VehicleOnboardingPrefs {
  static const _vehicleOnboardingCompletedKey = 'vehicle_onboarding_completed';

  static bool get() {
    return SharedPrefsHelper.prefs.getBool(_vehicleOnboardingCompletedKey) ??
        false;
  }

  static Future<void> set(bool completed) async {
    await SharedPrefsHelper.prefs
        .setBool(_vehicleOnboardingCompletedKey, completed);
  }
}
