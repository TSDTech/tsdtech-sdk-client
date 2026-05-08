import 'package:get_it/get_it.dart';
import 'package:voucherize/core/utils/module.base.dart';
import 'package:auto_route/auto_route.dart';
import 'package:voucherize/features/auth/core/stores/auth_store.dart';

class AuthModule extends ModuleBase {
  @override
  List<AutoRoute> get routes => [];

  @override
  void inject(GetIt sl) {
    // Register AuthStore as lazy singleton so GetIt.instance<AuthStore>() works
    if (!sl.isRegistered<AuthStore>()) {
      sl.registerLazySingleton(() => AuthStore());
    }
  }
}
