import 'package:get_it/get_it.dart';
import 'package:voucherize/core/services/intra-api/intra-api.module.dart';
import 'package:voucherize/core/utils/module.base.dart';
import 'package:voucherize/features/features.module.dart';

class MainModule extends ModuleBase {
  @override
  List<ModuleBase> get imports => [
    IntraApiModule(),
    FeaturesModule(),
  ];

  @override
  void inject(GetIt sl) {}
}
