import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';
import 'package:tsdtech_client_sdk/features/cart/cart.module.dart';
import 'package:tsdtech_client_sdk/features/settings_menu/settings_menu_module.dart';
import 'package:tsdtech_client_sdk/features/login/login.module.dart';
import 'package:tsdtech_client_sdk/features/auth/auth.module.dart';
import 'package:tsdtech_client_sdk/features/profile_menu/profile_menu.module.dart';
import 'package:tsdtech_client_sdk/features/purchase_history/purchase_history.module.dart';
import 'package:tsdtech_client_sdk/features/signup/signup.module.dart';
import 'package:tsdtech_client_sdk/features/services_catalog/services_catalog.module.dart';
import 'package:tsdtech_client_sdk/features/checkout/checkout.module.dart';
import 'package:tsdtech_client_sdk/features/vouchers/vouchers.module.dart';
import 'package:tsdtech_client_sdk/features/cart/core/stores/cart_store.dart';

class FeaturesModule extends ModuleBase {
  @override
  List<ModuleBase> get imports => [
        AuthModule(),
        LoginModule(),
        SignupModule(),
        ServicesCatalogModule(),
        VouchersModule(),
        CheckoutModule(),
        PurchaseHistoryModule(),
        CartModule(),
        SettingsMenuModule(),
        ProfileMenuModule(),
      ];

  @override
  void inject(GetIt sl) {
    if (!sl.isRegistered<CartStore>()) {
      sl.registerLazySingleton<CartStore>(() => CartStore());
    }
  }
}
