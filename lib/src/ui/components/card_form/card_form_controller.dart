import 'card_form_data.dart';

abstract class CardFormScope {
  bool validateForm();
  CardFormData buildData();
  void resetForm();
}

class CardFormController {
  CardFormScope? _scope;

  void attach(CardFormScope scope) => _scope = scope;
  void detach() => _scope = null;

  bool validate() => _scope?.validateForm() ?? false;
  CardFormData? get data => _scope?.buildData();
  bool get hasClient => _scope != null;

  void reset() => _scope?.resetForm();
}
