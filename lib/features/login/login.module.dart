import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';
import 'core/stores/login_store.dart';

class LoginModule extends ModuleBase {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/login',
          page: LoginRoute.page,
          meta: const {'requiresAuth': false},
          initial: true,
        ),
        AutoRoute(
          path: '/forgot-password',
          page: ForgotPasswordRoute.page,
          meta: const {'requiresAuth': false},
        ),
      ];

  @override
  void inject(GetIt sl) {
    sl.registerLazySingleton<LoginStore>(() => LoginStore());
  }
}
