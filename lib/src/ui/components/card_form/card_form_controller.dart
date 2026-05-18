import 'card_form_data.dart';
import '../../stores/card_form_store.dart';

abstract class CardFormScope {
  bool validateForm();
  CardFormData buildData();
  void resetForm();
}

class CardFormController {
  CardFormScope? _scope;
  CardFormStore? _store;

  void attach(CardFormScope scope) {
    _scope = scope;
    _store = null;
  }

  void bindStore(CardFormStore store) {
    _store = store;
    _scope = null;
  }

  void detach() {
    _scope = null;
    _store = null;
  }

  bool validate() => _scope?.validateForm() ?? _store?.validateForm() ?? false;
  CardFormData? get data => _scope?.buildData() ?? _store?.data;
  bool get hasClient => _scope != null || _store != null;

  void reset() {
    _scope?.resetForm();
    _store?.resetForm();
  }
}
