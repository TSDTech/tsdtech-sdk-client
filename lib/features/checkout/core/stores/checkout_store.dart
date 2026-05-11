import 'package:mobx/mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/core/local_storage/client_user_token_data/client_user_token_data.prefs.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:tsdtech_client_sdk/features/cart/core/stores/cart_store.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_request.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_item.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_response.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import '../models/payment_method.dart';

part 'checkout_store.g.dart';

class CheckoutStore = _CheckoutStoreBase with _$CheckoutStore;

class CardPaymentInput {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String securityCode;
  final String installments;

  const CardPaymentInput({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.securityCode,
    required this.installments,
  });
}

abstract class _CheckoutStoreBase with Store {
  final CartStore cart = GetIt.instance<CartStore>();
  late final ReactionDisposer _cartReactionDisposer;
  CardPaymentInput? _cardPaymentInput;

  @observable
  PaymentMethod selectedPayment = PaymentMethod.pix;

  @observable
  bool isProcessing = false;

  @observable
  double _total = 0.0;

  @computed
  double get total => _total;

  _CheckoutStoreBase() {
    // Automatically recalculate total when cart items change
    _cartReactionDisposer = reaction(
      (_) => cart.items,
      (_) => calculateTotal(),
    );

    // Calculate initial total
    calculateTotal();
  }

  void dispose() {
    _cartReactionDisposer();
  }

  @action
  void selectPayment(PaymentMethod m) {
    selectedPayment = m;
  }

  @action
  void selectByIndex(int idx) => selectedPayment = PaymentMethod.fromIndex(idx);

  void setCardPaymentInput(CardPaymentInput input) {
    _cardPaymentInput = input;
  }

  @action
  Future<void> calculateTotal() async {
    if (cart.items.isEmpty) {
      _total = 0.0;
      return;
    }

    // Convert CartItem to CalculateItem with only serviceId, price, and quantity
    final calculateItems = cart.items
        .map((cartItem) => CalculateItem(
              serviceId: cartItem.service.id ?? '',
              value: cartItem.service.price ?? 0.0,
              quantity: cartItem.quantity,
            ))
        .toList();

    final request = CalculateRequest(cart: calculateItems);
    final result = await CheckoutsService.instance.calculateCart(request);

    if (result.isSuccess && result.value != null) {
      _total = result.value!.totalValue;
    } else {
      _total = 0.0;
    }
  }

  @action
  Future<ValueResult<CheckoutResponse>> createCheckout(
      {String? encryptedCard}) async {
    isProcessing = true;
    final paymentMethodString = _getPaymentMethodString(selectedPayment);
    final card = _buildCardPaymentData();
    final installmentNumber =
        _parseInstallments(_cardPaymentInput?.installments);
    final billPayer = _buildBillPayerData();
    final billDueDate = _buildBillDueDateIso();
    final billInstructions = _buildBillInstructions();

    // Convert CartItem to CalculateItem with only serviceId, value, and quantity
    final cartItems = cart.items
        .map((cartItem) => CalculateItem(
              serviceId: cartItem.service.id ?? '',
              value: cartItem.service.price ?? 0.0,
              quantity: cartItem.quantity,
            ))
        .toList();

    final request = CheckoutRequest(
      cart: cartItems,
      paymentMethod: paymentMethodString,
      totalValue: _total,
      encryptedCard: encryptedCard,
      card: card,
      billPayer: billPayer,
      billDueDate: billDueDate,
      billInstructions: billInstructions,
      installmentNumber: installmentNumber,
    );

    try {
      return await CheckoutsService.instance.createCheckout(request);
    } finally {
      isProcessing = false;
    }
  }

  String _getPaymentMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.pix:
        return 'PIX';
      case PaymentMethod.card:
        return 'CREDIT_CARD';
      case PaymentMethod.boleto:
        return 'BILL';
    }
  }

  CardPaymentData? _buildCardPaymentData() {
    if (selectedPayment != PaymentMethod.card || _cardPaymentInput == null) {
      return null;
    }

    final input = _cardPaymentInput!;
    final cardNumber = input.cardNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final expiry = _toBackendCardExpiry(input.expiryDate);
    final securityCode = input.securityCode.replaceAll(RegExp(r'[^0-9]'), '');
    final holderName = input.cardHolderName.trim();

    if (cardNumber.isEmpty ||
        expiry.isEmpty ||
        securityCode.isEmpty ||
        holderName.isEmpty) {
      return null;
    }

    return CardPaymentData(
      cardHolderName: holderName,
      cardNumber: cardNumber,
      cardExpiryDate: expiry,
      securityCode: securityCode,
    );
  }

  String _toBackendCardExpiry(String value) {
    final parts = value.split('/');
    if (parts.length != 2) return '';
    final month = parts[0].padLeft(2, '0');
    final year = parts[1];
    if (year.length != 2 || month.length != 2) return '';
    return '20$year$month';
  }

  int? _parseInstallments(String? value) {
    if (value == null || value.isEmpty) return null;
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  BillPayerData? _buildBillPayerData() {
    if (selectedPayment != PaymentMethod.boleto) return null;

    final session = ClientUserTokenDataPrefs.get();
    final name = '${session?.name ?? ''} ${session?.secondName ?? ''}'.trim();
    final cpf = (session?.cpf ?? '').trim();
    final email = (session?.email ?? '').trim();
    final phone = (session?.phone ?? '').trim();

    // Session data complements payer identity; address fields are temporary
    // placeholders while the checkout flow has no address form yet.
    final composedAddressInfo =
        [cpf, email, phone].where((v) => v.isNotEmpty).join(' | ');

    return BillPayerData(
      name: name.isNotEmpty ? name : 'Cliente',
      address: composedAddressInfo.isNotEmpty
          ? 'Dados do cliente: $composedAddressInfo'
          : 'Endereco nao informado',
      neighborhood: 'Nao informado',
      city: 'Nao informado',
      zipCode: '00000000',
      state: 'NI',
    );
  }

  String? _buildBillDueDateIso() {
    if (selectedPayment != PaymentMethod.boleto) return null;
    final dueDate = DateTime.now().add(const Duration(days: 3)).toUtc();
    return dueDate.toIso8601String();
  }

  String? _buildBillInstructions() {
    if (selectedPayment != PaymentMethod.boleto) return null;
    return 'Vencimento em 3 dias corridos a partir da emissao.';
  }
}
