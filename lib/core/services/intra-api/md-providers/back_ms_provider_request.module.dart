import 'package:get_it/get_it.dart';
import 'package:voucherize/core/services/intra-api/md-providers/provider_requests_service.dart';
import 'package:voucherize/core/utils/module.base.dart';

class BackMsProviderRequestModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<ProviderRequestsService>()) {
      sl.registerLazySingleton<ProviderRequestsService>(() => ProviderRequestsService());
    }
  }
}
