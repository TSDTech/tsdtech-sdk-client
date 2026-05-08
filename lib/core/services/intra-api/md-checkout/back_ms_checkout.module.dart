import 'package:get_it/get_it.dart';
import 'package:voucherize/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:voucherize/core/utils/module.base.dart';

class BackMsCheckoutModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<CheckoutsService>()) {
      sl.registerLazySingleton<CheckoutsService>(() => CheckoutsService());
    }
  }
}
