import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-authorizers/client-users/auth_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-authorizers/memberships/memberships_service.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-authorizers/api_keys/api_keys_service.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';

class BackMsAuthorizerModule extends ModuleBase {
  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<AuthServiceClientUser>()) {
      sl.registerLazySingleton<AuthServiceClientUser>(() => AuthServiceClientUser());
    }
    if (!sl.isRegistered<MembershipsService>()) {
      sl.registerLazySingleton<MembershipsService>(() => MembershipsService());
    }
    if (!sl.isRegistered<ApiKeysService>()) {
      sl.registerLazySingleton<ApiKeysService>(() => ApiKeysService());
    }
  }
}
