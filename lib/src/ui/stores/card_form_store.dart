import 'package:mobx/mobx.dart';

import '../components/card_form/card_brand.dart';
import '../components/card_form/card_form_data.dart';

part 'card_form_store.g.dart';

class CardFormStore = CardFormStoreBase with _$CardFormStore;

abstract class CardFormStoreBase with Store {
  @observable
  String cardNumber = '';

  @observable
  String cardholderName = '';

  @observable
  String expiryDate = '';

  @observable
  String cvv = '';

  @observable
  String taxId = '';

  @observable
  CardBrand brand = CardBrand.unknown;

  @computed
  CardFormData get data => CardFormData(
        cardNumber: cardNumber,
        cardholderName: cardholderName,
        expiryDate: expiryDate,
        cvv: cvv,
        taxId: taxId,
        brand: brand,
      );

  @computed
  bool get isAmex => brand == CardBrand.amex;

  @computed
  bool get isEmpty {
    return cardNumber.isEmpty &&
        cardholderName.isEmpty &&
        expiryDate.isEmpty &&
        cvv.isEmpty &&
        taxId.isEmpty;
  }

  @action
  void updateCardNumber(String value) => cardNumber = value;

  @action
  void updateCardholderName(String value) => cardholderName = value;

  @action
  void updateExpiryDate(String value) => expiryDate = value;

  @action
  void updateCvv(String value) => cvv = value;

  @action
  void updateTaxId(String value) => taxId = value;

  @action
  void setBrand(CardBrand value) => brand = value;

  @action
  void setData(CardFormData value) {
    cardNumber = value.cardNumber;
    cardholderName = value.cardholderName;
    expiryDate = value.expiryDate;
    cvv = value.cvv;
    taxId = value.taxId;
    brand = value.brand;
  }

  @action
  void reset() {
    cardNumber = '';
    cardholderName = '';
    expiryDate = '';
    cvv = '';
    taxId = '';
    brand = CardBrand.unknown;
  }
}