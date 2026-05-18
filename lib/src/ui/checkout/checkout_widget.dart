import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../../core/services/intra-api/md-checkout/checkouts_service.dart';
import '../../../models/cart/cart_item.model.dart';
import '../../../models/checkouts/calculate_item.model.dart';
import '../../../models/checkouts/checkout_request.model.dart';
import '../../crypto/card_encryptor.dart';
import '../stores/checkout_store.dart';
import 'checkout_states.dart';
import 'payment_method_selector.dart';
import 'payment_types.dart';
import 'views/card_payment_view.dart';
import 'views/pix_payment_view.dart';

class CheckoutWidgetController {
  CheckoutWidgetController({
    PaymentMethodType initialMethod = PaymentMethodType.pix,
  }) : selectedMethod = ValueNotifier(initialMethod);

  final ValueNotifier<PaymentMethodType> selectedMethod;
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> hasGeneratedPix = ValueNotifier(false);

  Future<void> Function()? _submitPayment;

  Future<void> submitPayment() async {
    final submitPayment = _submitPayment;
    if (submitPayment != null) {
      await submitPayment();
    }
  }

  void dispose() {
    selectedMethod.dispose();
    isLoading.dispose();
    hasGeneratedPix.dispose();
  }
}

class CheckoutWidget extends StatefulWidget {
  final List<CartItem> items;
  final String administratorId;
  final String gatewayPublicKey;
  final void Function(PaymentResult)? onSuccess;
  final void Function(String)? onError;
  final void Function(PaymentStatus)? onStatusChange;
  final bool showPix;
  final bool showCard;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool showSubmitButton;
  final CheckoutWidgetController? controller;
  final CheckoutStore? store;

  const CheckoutWidget({
    super.key,
    required this.items,
    required this.administratorId,
    required this.gatewayPublicKey,
    this.onSuccess,
    this.onError,
    this.onStatusChange,
    this.showPix = true,
    this.showCard = true,
    this.loadingWidget,
    this.errorWidget,
    this.showSubmitButton = true,
    this.controller,
    this.store,
  });

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  late CheckoutStore _store;
  ReactionDisposer? _controllerSyncDisposer;
  
  // Controllers do Cartão (O pai precisa gerenciar para acessar os dados)
  final _formKey = GlobalKey<FormState>();
  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _securityCodeController = TextEditingController();

  // Estados dos pagamentos dinâmicos
  String? _pixQrCode;
  String? _pixCopyPasteCode;
  String? _paymentId;
  Timer? _pixPollingTimer;

  @override
  void initState() {
    super.initState();
    _configureStore();
  }

  @override
  void didUpdateWidget(covariant CheckoutWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.store != widget.store) {
      _configureStore();
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._submitPayment = null;
      _syncControllerState();
    }
  }

  @override
  void dispose() {
    widget.controller?._submitPayment = null;
    _pixPollingTimer?.cancel();
    _controllerSyncDisposer?.call();
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  void _notifyStatus(PaymentStatus status) {
    widget.onStatusChange?.call(status);
  }

  void _configureStore() {
    _controllerSyncDisposer?.call();
    _store = widget.store ?? CheckoutStore(
      initialMethod: widget.showPix
          ? PaymentMethodType.pix
          : PaymentMethodType.card,
    );
    _controllerSyncDisposer = autorun((_) {
      _store.selectedMethod;
      _store.isLoading;
      _store.hasGeneratedPix;
      _syncControllerState();
    });
  }

  void _syncControllerState() {
    final controller = widget.controller;
    if (controller == null) {
      return;
    }

    controller._submitPayment = _processPayment;
    controller.selectedMethod.value = _store.selectedMethod;
    controller.isLoading.value = _store.isLoading;
    controller.hasGeneratedPix.value = _store.hasGeneratedPix;
  }

  List<CalculateItem> _buildCalculateItems() {
    return widget.items.map((item) {
      return CalculateItem(
        serviceId: item.service.id ?? '',
        value: item.service.price ?? 0.0,
        quantity: item.quantity,
      );
    }).toList();
  }

  double get _totalValue {
    return widget.items.fold<double>(0.0, (sum, item) {
      return sum + (item.service.price ?? 0.0) * item.quantity;
    });
  }

  String _methodToApiString(PaymentMethodType method) {
    switch (method) {
      case PaymentMethodType.pix:
        return 'pix';
      case PaymentMethodType.card:
        return 'card';
    }
  }

  Future<void> _processPayment() async {
    if (_store.isCardSelected) {
      if (!_formKey.currentState!.validate()) return;
      if (widget.gatewayPublicKey.trim().isEmpty) {
        _showError('A chave pública do gateway não pode ficar vazia.');
        return;
      }
    }

    _store.setLoading(true);
    _syncControllerState();
    _store.clearError();
    _notifyStatus(PaymentStatus.processing);

    try {
      final cartItems = _buildCalculateItems();
      final checkoutRequest = CheckoutRequest(
        cart: cartItems,
        paymentMethod: _methodToApiString(_store.selectedMethod),
        totalValue: _totalValue,
        encryptedCard: _store.isCardSelected
            ? _buildEncryptedCardData()
            : null,
      );

      final result = await CheckoutsService.instance.createCheckout(checkoutRequest);
      
      if (!result.isSuccess) {
        _showError(result.error.toString());
        return;
      }

      final response = result.value!;
      
      if (_store.isPixSelected) {
        _store.setPixData(
          paymentId: response.paymentId,
          qrCode: response.pix?.qrCode,
          copyPasteCode: response.pix?.copyPasteCode,
        );
        _notifyStatus(PaymentStatus.waitingPayment);
        
        if (_store.paymentId != null) {
          _startPixPolling(_store.paymentId!);
        }
        _syncControllerState();
      } else if (_store.isCardSelected) {
        _handleSuccess(
          response.paymentId ?? response.depositRequestId ?? 'card_${DateTime.now().millisecondsSinceEpoch}',
          depositRequestId: response.depositRequestId,
        );
      }
    } catch (error) {
      _showError(error.toString());
    } finally {
      _store.setLoading(false);
      _syncControllerState();
    }
  }

  String _toBackendCardExpiry(String value) {
    final parts = value.split('/');
    if (parts.length != 2) return '';
    final month = parts[0].padLeft(2, '0');
    final year = parts[1];
    return '20$year$month'; // Converte MM/AA para 20AAMM
  }

  String _buildEncryptedCardData() {
    final cardData = CardPaymentData(
      cardHolderName: _cardHolderController.text.trim(),
      cardNumber: _cardNumberController.text.trim(),
      cardExpiryDate: _toBackendCardExpiry(_expiryController.text.trim()), // <-- Correção aqui
      securityCode: _securityCodeController.text.trim(),
    );
    return CardEncryptor.encrypt(widget.gatewayPublicKey, cardData);
  }

  void _showError(String message) {
    _store.setError(message);
    widget.onError?.call(message);
    _notifyStatus(PaymentStatus.failed);
    _syncControllerState();
  }

  void _startPixPolling(String paymentId) {
    _pixPollingTimer?.cancel();
    _pixPollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final statusResult = await CheckoutsService.instance.getPixStatus(paymentId);
        if (!statusResult.isSuccess) return;
        
        final status = statusResult.value?.toLowerCase() ?? '';
        if (status == 'paid' || status == 'completed' || status == 'success') {
          timer.cancel();
          _handleSuccess(paymentId, pixQrCode: _store.pixQrCode);
        }
      } catch (_) {
        // Ignored: manter polling
      }
    });
  }

  void _handleSuccess(
    String transactionId, {
    String? pixQrCode,
    String? depositRequestId,
    String? message,
  }) {
    _notifyStatus(PaymentStatus.success);
    final result = PaymentResult(
      transactionId: transactionId,
      method: _store.selectedMethod,
      status: PaymentStatus.success,
      pixQrCode: pixQrCode,
      depositRequestId: depositRequestId,
      message: message,
    );
    _store.setPaymentResult(result);
    widget.onSuccess?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_store.isLoading) {
          return CheckoutLoadingState(customLoading: widget.loadingWidget);
        }

        if (_store.hasError) {
          return CheckoutErrorState(
            message: _store.errorMessage!,
            onRetry: _processPayment,
            customError: widget.errorWidget,
          );
        }

        final method = _store.selectedMethod;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            PaymentMethodSelector(
              selectedMethod: method,
              onChanged: (newMethod) {
                _store.selectMethod(newMethod);
                _pixPollingTimer?.cancel();
                _syncControllerState();
              },
              showPix: widget.showPix,
              showCard: widget.showCard,
            ),
            const SizedBox(height: 24),
            switch (method) {
              PaymentMethodType.pix => PixPaymentView(
                  qrCode: _store.pixQrCode,
                  copyPasteCode: _store.pixCopyPasteCode,
                ),
              PaymentMethodType.card => CardPaymentView(
                  formKey: _formKey,
                  cardHolderController: _cardHolderController,
                  cardNumberController: _cardNumberController,
                  expiryController: _expiryController,
                  securityCodeController: _securityCodeController,
                ),
            },
            const SizedBox(height: 24),
            if (widget.showSubmitButton &&
                !(method == PaymentMethodType.pix && _store.hasGeneratedPix))
              ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  method == PaymentMethodType.card ? 'Pagar Agora' : 'Gerar Pagamento',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        );
      },
    );
  }
}