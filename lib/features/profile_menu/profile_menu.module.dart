import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/guards/auth.guard.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';
import 'package:tsdtech_client_sdk/features/profile_menu/core/profile_menu_store.dart';

class ProfileMenuModule extends ModuleBase {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/profile-menu',
          page: ProfileMenuRoute.page,
          meta: const {'requiresAuth': true},
          guards: [AuthGuard()],
        ),
      ];

  @override
  void inject(GetIt sl) {
    sl.registerLazySingleton<ProfileMenuStore>(() => ProfileMenuStore());
  }
}
