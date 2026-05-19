import 'package:mobx/mobx.dart';

import '../components/card_form/card_form_data.dart';
import '../widgets/payment_form/payment_form_data.dart';
import '../widgets/payment_form/payment_form_method.dart';
import 'card_form_store.dart';

part 'payment_store.g.dart';

class PaymentStore = PaymentStoreBase with _$PaymentStore;

abstract class PaymentStoreBase with Store {
  PaymentStoreBase({
    PaymentFormMethod initialMethod = PaymentFormMethod.pix,
    CardFormStore? cardFormStore,
  }) : _initialMethod = initialMethod,
       cardFormStore = cardFormStore ?? CardFormStore(),
       selectedMethod = initialMethod;

  final PaymentFormMethod _initialMethod;
  final CardFormStore cardFormStore;

  @observable
  PaymentFormMethod selectedMethod;

  @observable
  bool enabled = true;

  @observable
  bool isLoading = false;

  @observable
  PaymentFormData? lastSubmittedData;

  @computed
  bool get canInteract => enabled && !isLoading;

  @computed
  bool get isCardSelected => selectedMethod == PaymentFormMethod.card;

  @computed
  bool get isPixSelected => selectedMethod == PaymentFormMethod.pix;

  @computed
  CardFormData? get selectedCardData =>
      isCardSelected ? cardFormStore.data : null;

  @computed
  PaymentFormData get currentData =>
      PaymentFormData(method: selectedMethod, cardData: selectedCardData);

  @action
  void selectMethod(PaymentFormMethod method) {
    if (!canInteract || selectedMethod == method) {
      return;
    }

    selectedMethod = method;
  }

  @action
  void setEnabled(bool value) => enabled = value;

  @action
  void setLoading(bool value) => isLoading = value;

  @action
  void setCardData(CardFormData value) => cardFormStore.setData(value);

  @action
  void markSubmitted() => lastSubmittedData = currentData;

  @action
  void clearSubmission() => lastSubmittedData = null;

  @action
  void reset() {
    selectedMethod = _initialMethod;
    enabled = true;
    isLoading = false;
    lastSubmittedData = null;
    cardFormStore.reset();
  }
}
