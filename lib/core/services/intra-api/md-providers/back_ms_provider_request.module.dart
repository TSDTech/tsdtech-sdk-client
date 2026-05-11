import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-providers/provider_requests_service.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';

class BackMsProviderRequestModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<ProviderRequestsService>()) {
      sl.registerLazySingleton<ProviderRequestsService>(
          () => ProviderRequestsService());
    }
  }
}
