import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-orders/orders_service.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';

class BackMsAuthorizerModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<OrdersService>()) {
      sl.registerLazySingleton<OrdersService>(() => OrdersService());
    }

  }
}
