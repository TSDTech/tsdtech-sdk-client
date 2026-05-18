import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-administrators/administrators_service.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';

class BackMsAdministratorsModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<AdministratorsService>()) {
      sl.registerLazySingleton<AdministratorsService>(
        () => AdministratorsService(),
      );
    }
  }
}
