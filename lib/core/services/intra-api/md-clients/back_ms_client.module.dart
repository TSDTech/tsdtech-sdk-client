import 'package:get_it/get_it.dart';
import 'package:voucherize/core/services/intra-api/md-clients/clients_service.dart';
import 'package:voucherize/core/utils/module.base.dart';

class BackMsClientsModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<ClientsService>()) {
      sl.registerLazySingleton<ClientsService>(() => ClientsService());
    }

  }
}
