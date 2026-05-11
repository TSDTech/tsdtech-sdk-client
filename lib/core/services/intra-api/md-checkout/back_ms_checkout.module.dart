import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';

class BackMsCheckoutModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<CheckoutsService>()) {
      sl.registerLazySingleton<CheckoutsService>(() => CheckoutsService());
    }
  }
}
