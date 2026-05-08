import 'package:get_it/get_it.dart';
import 'package:voucherize/core/services/intra-api/md-services/services/services_service.dart';
import 'package:voucherize/core/services/intra-api/md-services/services/service_types_service.dart';
import 'package:voucherize/core/utils/module.base.dart';

class BackMsServicesModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<ServicesService>()) {
      sl.registerLazySingleton<ServicesService>(() => ServicesService());
    }
    if (!sl.isRegistered<ServiceTypesService>()) {
      sl.registerLazySingleton<ServiceTypesService>(() => ServiceTypesService());
    }
  }
}
