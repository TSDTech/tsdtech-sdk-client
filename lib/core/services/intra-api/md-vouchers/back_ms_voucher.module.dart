import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-vouchers/vouchers_service.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';

class BackMsVouchersModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<VouchersService>()) {
      sl.registerLazySingleton<VouchersService>(() => VouchersService());
    }
  }
}
