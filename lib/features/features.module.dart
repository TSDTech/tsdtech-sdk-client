import 'package:get_it/get_it.dart';
import 'package:voucherize/core/utils/module.base.dart';
import 'package:voucherize/features/cart/cart.module.dart';
import 'package:voucherize/features/settings_menu/settings_menu_module.dart';
import 'package:voucherize/features/login/login.module.dart';
import 'package:voucherize/features/auth/auth.module.dart';
import 'package:voucherize/features/profile_menu/profile_menu.module.dart';
import 'package:voucherize/features/purchase_history/purchase_history.module.dart';
import 'package:voucherize/features/signup/signup.module.dart';
import 'package:voucherize/features/services_catalog/services_catalog.module.dart';
import 'package:voucherize/features/checkout/checkout.module.dart';
import 'package:voucherize/features/vouchers/vouchers.module.dart';
import 'package:voucherize/features/cart/core/stores/cart_store.dart';

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
