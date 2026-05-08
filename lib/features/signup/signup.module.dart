import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:voucherize/core/utils/module.base.dart';
import 'package:voucherize/core/router/router.dart';
  import 'core/stores/signup_type_store.dart';
  import 'core/stores/signup_person_store.dart';

class SignupModule extends ModuleBase {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/signup',
          page: SignupPersonRoute.page,
          meta: const {'requiresAuth': false},
        )
      ];

  @override
  void inject(GetIt sl) {
    // register stores used by signup feature
    if (!sl.isRegistered<SignupTypeStore>()) {
      sl.registerLazySingleton(() => SignupTypeStore());
    }
    if (!sl.isRegistered<SignupPersonStore>()) {
      sl.registerLazySingleton(() => SignupPersonStore());
    }
  }
}
