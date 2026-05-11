import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-clients/clients_service.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';

class BackMsClientsModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<ClientsService>()) {
      sl.registerLazySingleton<ClientsService>(() => ClientsService());
    }

  }
}
