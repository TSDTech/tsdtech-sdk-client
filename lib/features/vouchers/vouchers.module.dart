import 'package:get_it/get_it.dart';
import 'package:auto_route/auto_route.dart';
import 'package:voucherize/core/guards/auth.guard.dart';
import 'package:voucherize/core/router/router.dart';
import 'package:voucherize/core/utils/module.base.dart';
import 'package:voucherize/features/vouchers/core/stores/provider_request_store.dart';
import 'core/stores/vouchers_store.dart';

class VouchersModule extends ModuleBase {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/vouchers',
          page: MyVouchersRoute.page,
          meta: const {'requiresAuth': true},
          guards: [AuthGuard()],
        ),
        AutoRoute(
          path: '/vouchers/form',
          page: MyVouchersFormRoute.page,
          meta: const {'requiresAuth': true},
          guards: [AuthGuard()],
        ),  
        AutoRoute(
          path: '/vouchers/request/qrcode',
          page: ProviderRequestQRCodeRoute.page,  
          meta: const {'requiresAuth': true},
          guards: [AuthGuard()],
        ),  
        AutoRoute(
          path: '/vouchers/request/form',
          page: ProviderRequestFormRoute.page,
          meta: const {'requiresAuth': true},
          guards: [AuthGuard()],
        ),
        AutoRoute(
          path: '/vouchers/request/finished',
          page: ProviderRequestFinishedRoute.page,
          meta: const {'requiresAuth': true},
          guards: [AuthGuard()],
        ),
      ];

  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<VouchersStore>()) {
      sl.registerLazySingleton<VouchersStore>(() => VouchersStore());
    }
    if (!sl.isRegistered<ProviderRequestStore>()) {
      sl.registerLazySingleton<ProviderRequestStore>(() => ProviderRequestStore());
    }
  }
}
