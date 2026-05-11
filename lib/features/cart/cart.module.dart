import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';
import 'package:auto_route/auto_route.dart';

class CartModule extends ModuleBase {
  @override
  List<AutoRoute> get routes => [];

  @override
  void inject(GetIt sl) {
    // Cart store registration happens in FeaturesModule to keep centralized.
  }
}
