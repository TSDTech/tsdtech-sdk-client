import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/src/components/checkout_states.dart';
import 'package:tsdtech_client_sdk/src/components/payment_types.dart';
import '../../core/services/intra-api/md-checkout/checkouts_service.dart';
import '../../models/cart/cart_item.model.dart';
import '../../models/checkouts/calculate_item.model.dart';
import '../../models/checkouts/checkout_request.model.dart';
import '../crypto/card_encryptor.dart';
import '../components/payment_method_selector.dart';
import 'views/card_payment_view.dart';
import 'views/pix_payment_view.dart';

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
  });

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  late final ValueNotifier<PaymentMethodType> _selectedMethod;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<String?> _errorMessage = ValueNotifier(null);
  
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
    final initialMethod = widget.showPix
        ? PaymentMethodType.pix
        : PaymentMethodType.card;
    _selectedMethod = ValueNotifier(initialMethod);
  }

  @override
  void dispose() {
    _pixPollingTimer?.cancel();
    _selectedMethod.dispose();
    _isLoading.dispose();
    _errorMessage.dispose();
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  void _notifyStatus(PaymentStatus status) {
    widget.onStatusChange?.call(status);
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
    if (_selectedMethod.value == PaymentMethodType.card) {
      if (!_formKey.currentState!.validate()) return;
      if (widget.gatewayPublicKey.trim().isEmpty) {
        _showError('A chave pública do gateway não pode ficar vazia.');
        return;
      }
    }

    _isLoading.value = true;
    _errorMessage.value = null;
    _notifyStatus(PaymentStatus.processing);

    try {
      final cartItems = _buildCalculateItems();
      final checkoutRequest = CheckoutRequest(
        cart: cartItems,
        paymentMethod: _methodToApiString(_selectedMethod.value),
        totalValue: _totalValue,
        encryptedCard: _selectedMethod.value == PaymentMethodType.card
            ? _buildEncryptedCardData()
            : null,
      );

      final result = await CheckoutsService.instance.createCheckout(checkoutRequest);
      
      if (!result.isSuccess) {
        _showError(result.error.toString());
        return;
      }

      final response = result.value!;
      
      if (_selectedMethod.value == PaymentMethodType.pix) {
        _paymentId = response.paymentId;
        _pixQrCode = response.pix?.qrCode;
        _pixCopyPasteCode = response.pix?.copyPasteCode;
        _notifyStatus(PaymentStatus.waitingPayment);
        
        if (_paymentId != null) {
          _startPixPolling(_paymentId!);
        }
      } else if (_selectedMethod.value == PaymentMethodType.card) {
        _handleSuccess(
          response.paymentId ?? response.depositRequestId ?? 'card_${DateTime.now().millisecondsSinceEpoch}',
          depositRequestId: response.depositRequestId,
        );
      }
    } catch (error) {
      _showError(error.toString());
    } finally {
      _isLoading.value = false;
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
    _errorMessage.value = message;
    widget.onError?.call(message);
    _notifyStatus(PaymentStatus.failed);
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
          _handleSuccess(paymentId, pixQrCode: _pixQrCode);
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
    widget.onSuccess?.call(PaymentResult(
      transactionId: transactionId,
      method: _selectedMethod.value,
      status: PaymentStatus.success,
      pixQrCode: pixQrCode,
      depositRequestId: depositRequestId,
      message: message,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return CheckoutLoadingState(customLoading: widget.loadingWidget);
        }

        return ValueListenableBuilder<String?>(
          valueListenable: _errorMessage,
          builder: (context, error, _) {
            if (error != null) {
              return CheckoutErrorState(
                message: error,
                onRetry: _processPayment,
                customError: widget.errorWidget,
              );
            }

            return ValueListenableBuilder<PaymentMethodType>(
              valueListenable: _selectedMethod,
              builder: (context, method, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PaymentMethodSelector(
                      selectedMethod: method,
                      onChanged: (newMethod) {
                        _selectedMethod.value = newMethod;
                        // Resetamos as variáveis visuais de conclusão ao trocar de método
                        _pixQrCode = null;
                        _pixCopyPasteCode = null;
                        _pixPollingTimer?.cancel();
                        setState(() {});
                      },
                      showPix: widget.showPix,
                      showCard: widget.showCard,
                    ),
                    const SizedBox(height: 24),
                    
                    // Renderização elegante via Switch case utilizando nossos novos widgets
                    switch (method) {
                      PaymentMethodType.pix => PixPaymentView(
                          qrCode: _pixQrCode,
                          copyPasteCode: _pixCopyPasteCode,
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
                    
                    // Oculta o botão se o PIX já foi gerado
                    if (!(method == PaymentMethodType.pix && _pixQrCode != null))
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
          },
        );
      },
    );
  }
}