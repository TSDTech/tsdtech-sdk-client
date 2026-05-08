import 'package:get_it/get_it.dart';
import 'package:voucherize/core/guards/auth.guard.dart';
import 'package:voucherize/core/utils/module.base.dart';
import 'package:auto_route/auto_route.dart';
import 'package:voucherize/core/router/router.dart';
import 'package:voucherize/features/settings_menu/core/settings_menu_store.dart';

class SettingsMenuModule extends ModuleBase {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/settings-menu',
          page: SettingsMenuRoute.page,
          meta: const {'requiresAuth': true},
          guards: [AuthGuard()],
        ),
      ];

  @override
  void inject(GetIt sl) {
    sl.registerLazySingleton<SettingsMenuStore>(() => SettingsMenuStore());
  }
}