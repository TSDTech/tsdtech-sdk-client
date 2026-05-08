import 'package:get_it/get_it.dart';
import 'package:voucherize/core/guards/auth.guard.dart';
import 'package:voucherize/core/router/router.dart';
import 'core/stores/checkout_store.dart';
import 'package:voucherize/core/utils/module.base.dart';
import 'package:auto_route/auto_route.dart';

class CheckoutModule extends ModuleBase {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/checkout', page: CheckoutRoute.page, meta: const {'requiresAuth': true}, guards: [AuthGuard()],),
      ];

  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<CheckoutStore>()) {
      sl.registerLazySingleton<CheckoutStore>(() => CheckoutStore());
    }
  }
}
