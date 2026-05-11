import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/intra-api.module.dart';
import 'package:tsdtech_client_sdk/core/utils/module.base.dart';
import 'package:tsdtech_client_sdk/features/features.module.dart';

class MainModule extends ModuleBase {
  @override
  List<ModuleBase> get imports => [
    IntraApiModule(),
    FeaturesModule(),
  ];

  @override
  void inject(GetIt sl) {}
}
