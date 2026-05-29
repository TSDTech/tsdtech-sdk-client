import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:tsdtech_client_sdk/src/ui/components/checkout/order_summary_card.dart';
import 'package:tsdtech_client_sdk/src/ui/components/demo/demo_components.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
// import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart' as checkout_request;
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';

class CheckoutWidgetController {
  CheckoutWidgetController()
    : selectedMethod = ValueNotifier(PaymentMethodType.pix);

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
  final List<CartItem>? items;
  final String? administratorId;
  final String? depositRequestId;
  final String? gatewayPublicKey;
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
    this.items,
    this.administratorId,
    this.depositRequestId,
    this.gatewayPublicKey,
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
  // Variável local de estado para renderizar a tela de sucesso
  PaymentStatus? _currentStatus;
  late final CheckoutStore _internalStore;

  @override
  void initState() {
    super.initState();
    // A store nasce junto com o Widget e mantém os dados seguros
    _internalStore = CheckoutStore(); 
    _internalStore.fetchOrderSummary(widget.depositRequestId!);
  }

  @override
  void dispose() {
    // 3. Quando o SPA fechar a tela, a gente limpa a memória automaticamente
    _internalStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStore = widget.store ?? _internalStore;
    final theme = TsdtechUiConfig.instance.theme;
    
    // Formatador oficial pra injetar no OrderSummaryCard
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    void notifyStatus(PaymentStatus status) {
      setState(() => _currentStatus = status);
      widget.onStatusChange?.call(status);
    }

    void syncControllerState(Future<void> Function() submitPayment) {
      final checkoutController = widget.controller;
      if (checkoutController == null) {
        return;
      }

      checkoutController._submitPayment = submitPayment;
      checkoutController.selectedMethod.value = effectiveStore.selectedMethod;
      checkoutController.isLoading.value = effectiveStore.isLoading;
      checkoutController.hasGeneratedPix.value = effectiveStore.hasGeneratedPix;
    }

    // List<CalculateItem> buildCalculateItems() {
    //   return _internalStore.items.map((item) {
    //     return CalculateItem(
    //       serviceId: item.name,
    //       value: item.price,
    //       quantity: item.quantity,
    //     );
    //   }).toList();
    // }

    // final totalValue = _internalStore.items.fold<double>(0.0, (sum, item) {
    //   return sum + (item.price) * item.quantity;
    // });

    // String methodToApiString(PaymentMethodType method) {
    //   switch (method) {
    //     case PaymentMethodType.pix:
    //       return 'pix';
    //     case PaymentMethodType.card:
    //       return 'card';
    //   }
    // }

    void showError(String message, Future<void> Function() submitPayment) {
      effectiveStore.setError(message);
      widget.onError?.call(message);
      notifyStatus(PaymentStatus.failed);
      syncControllerState(submitPayment);
    }

    void handleSuccess(
      String transactionId,
      Future<void> Function() submitPayment, {
      String? pixQrCode,
      String? depositRequestId,
      String? message,
    }) {
      notifyStatus(PaymentStatus.success);
      final result = PaymentResult(
        transactionId: transactionId,
        method: effectiveStore.selectedMethod,
        status: PaymentStatus.success,
        pixQrCode: pixQrCode,
        depositRequestId: depositRequestId,
        message: message,
      );
      effectiveStore.setPaymentResult(result);
      widget.onSuccess?.call(result);
      syncControllerState(submitPayment);
    }

    Future<void> processPayment() async {
      if (effectiveStore.isCardSelected) {
        if (!effectiveStore.validateCardForm()) return;
      } 

      effectiveStore.setLoading(true);
      syncControllerState(processPayment);
      effectiveStore.clearError();
      notifyStatus(PaymentStatus.processing);

      try {
        final depositRequestId = widget.depositRequestId ?? await MockBackendSpaService.createOrderAndGetDepositId();
        // final dynamic result;

        // final request = checkout_request.CheckoutRequest(
        //   cart: buildCalculateItems(),
        //   paymentMethod: methodToApiString(effectiveStore.selectedMethod),
        //   totalValue: totalValue,
        //   depositRequestId: depositRequestId,
        // );

        final result = await effectiveStore.processPayment(
          depositRequestId: depositRequestId,
          // request: request,
        );

        if (!result.isSuccess) {
          showError(result.error.toString(), processPayment);
          return;
        }

        final response = result.value!;

        if (effectiveStore.isPixSelected) {
          notifyStatus(PaymentStatus.waitingPayment);

          if (effectiveStore.paymentId != null) {
            effectiveStore.startPixPollingWithBackoff(
              effectiveStore.paymentId!,
              onSuccess: () {
                handleSuccess(
                  effectiveStore.paymentId!, // Aqui pode ser o transactionId da Store
                  processPayment,
                  depositRequestId: depositRequestId,
                  pixQrCode: effectiveStore.pixQrCode,
                );
              },
            );
          }
          syncControllerState(processPayment);
        } else if (effectiveStore.isCardSelected) {
          handleSuccess(
            response.id,
            processPayment,
            depositRequestId: response.id,
          );
        }
      } catch (error) {
        showError(error.toString(), processPayment);
      } finally {
        effectiveStore.setLoading(false);
        syncControllerState(processPayment);
      }
    }

    syncControllerState(processPayment);

    // ==========================================
    // BUILDER PRINCIPAL DA TELA
    // ==========================================
    return Observer(
      builder: (_) {
        syncControllerState(processPayment);
        
        // 1. Tratamento de Loading 
        if (effectiveStore.isLoading) {
          return widget.loadingWidget ?? const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            )
          );
        }

        // 2. Tela de Sucesso Amigável (Fim do fluxo)
        if (_currentStatus == PaymentStatus.success) {
          return CheckoutSuccessState(
            customSuccess: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.green, size: 72),
                      const SizedBox(height: 16),
                      const Text('Pagamento realizado com sucesso!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      // const SizedBox(height: 8),
                      // Text('Pedido: ${widget.depositRequestId}', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text('Voltar ao catálogo'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            message:  'Pagamento realizado com sucesso!',
          );
          
        }

        // 3. Tela de Erro Amigável (Fim do fluxo ruim)
        if (_currentStatus == PaymentStatus.failed || effectiveStore.hasError) {
           if (effectiveStore.hasError) {
            return CheckoutErrorState(
              message: effectiveStore.errorMessage!,
              onRetry: () => Navigator.popUntil(context, (route) => route.isFirst),
              // onRetry: () => { effectiveStore.clearError(), effectiveStore.clearPixData() },
            );
          }
        }

        // 4. Fluxo Normal de Checkout (Formulário)
        final method = effectiveStore.selectedMethod;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              OrderSummaryCard(
                items: _internalStore.items.map((item) => CartItem(
                  service: Service(name: item.name, price: item.price),
                  quantity: item.quantity,
                )).toList(),
                totalValue: _internalStore.amount, 
                currencyFormat: currencyFormat,
              ),
              const SizedBox(height: 24), 
              
              // Container que envelopa o pagamento
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pagamento', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    
                    PaymentMethodSelector(
                      selectedMethod: method,
                      onChanged: (newMethod) {
                        effectiveStore.selectMethod(newMethod);
                        syncControllerState(processPayment);
                      },
                      showPix: widget.showPix,
                      showCard: widget.showCard,
                    ),
                    const SizedBox(height: 24),
                    
                    switch (method) {
                      PaymentMethodType.pix => PixPaymentView(
                        qrCode: effectiveStore.pixQrCode,
                        copyPasteCode: effectiveStore.pixCopyPasteCode,
                        expiresAt: effectiveStore.pixExpirationDate,

                      ),
                      PaymentMethodType.card => CardPaymentView(
                        formKey: effectiveStore.cardFormKey,
                        formVersion: effectiveStore.cardFormVersion,
                        cardHolderName: effectiveStore.cardHolderName,
                        cardNumber: effectiveStore.cardNumber,
                        expiryDate: effectiveStore.expiryDate,
                        securityCode: effectiveStore.securityCode,
                        onCardHolderChanged: effectiveStore.updateCardHolderName,
                        onCardNumberChanged: effectiveStore.updateCardNumber,
                        onExpiryChanged: effectiveStore.updateExpiryDate,
                        onSecurityCodeChanged: effectiveStore.updateSecurityCode,
                        taxId: effectiveStore.taxId,
                        onTaxIdChanged: effectiveStore.updateTaxId,
                      ),
                    },
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              if (widget.showSubmitButton && !(method == PaymentMethodType.pix && effectiveStore.hasGeneratedPix))
                ElevatedButton(
                  onPressed: processPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    method == PaymentMethodType.card ? 'Pagar Agora' : 'Gerar Pagamento',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 24),
              StatusBanner(status: _currentStatus),
            ],
          ),
        );
      },
    );
  }
}

class MockBackendSpaService {
  static Future<String> createOrderAndGetDepositId() async {
    await Future.delayed(const Duration(seconds: 1)); 
    return 'acaa27a1-ade2-45ea-a8b0-3f619ba5ae8f'; 
  }
}