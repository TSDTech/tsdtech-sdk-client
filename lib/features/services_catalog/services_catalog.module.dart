import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';
import 'core/stores/home_store.dart';

class ServicesCatalogModule extends ModuleBase {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          meta: const {'requiresAuth': false},
          initial: false,
        ),
      ];

  @override
  void inject(GetIt sl) {
    sl.registerLazySingleton<HomeStore>(() => HomeStore());
  }
}
