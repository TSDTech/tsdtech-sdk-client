import 'package:get_it/get_it.dart';

abstract class ModuleBase {
  List<ModuleBase> get imports => const [];

  void registerStores(GetIt sl) {
    for (final module in imports) {
      module.registerStores(sl);
    }

    inject(sl);
  }

  void inject(GetIt sl);
}