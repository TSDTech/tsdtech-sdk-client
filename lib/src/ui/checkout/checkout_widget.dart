import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:tsdtech_client_sdk/src/ui/components/checkout/order_summary_card.dart';
import 'package:tsdtech_client_sdk/src/ui/components/checkout/status_banner.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';

class CheckoutWidgetController {
  CheckoutWidgetController()
    : selectedMethod = ValueNotifier(PaymentMethodType.pix);

  final ValueNotifier<PaymentMethodType> selectedMethod;
  final ValueNotifier<bool> hasSelectedMethod = ValueNotifier(false);
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
    hasSelectedMethod.dispose();
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

  /// Quando `true`, usa o [MockBackendSpaService] para obter um
  /// depositRequestId fixo em vez de criar o checkout no backend.
  /// Apenas para testes/demos locais.
  final bool debugUseMockBackend;

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
    this.debugUseMockBackend = true,
  });

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  // Variável local de estado para renderizar a tela de sucesso
  PaymentStatus? _currentStatus;
  bool _hasSelectedMethod = false;
  late final CheckoutStore _internalStore;

  // Guarda o depositRequestId criado pelo próprio SDK quando o widget não
  // recebe um via widget.depositRequestId (fluxo onde o SDK cria o checkout).
  String? _createdDepositRequestId;

  CheckoutStore get _effectiveStore => widget.store ?? _internalStore;

  @override
  void initState() {
    super.initState();
    // A store nasce junto com o Widget e mantém os dados seguros
    _internalStore = CheckoutStore();

    final providedId =
        widget.depositRequestId ??
        (widget.debugUseMockBackend
            ? MockBackendSpaService.createOrderAndGetDepositId()
            : null);
    if (providedId != null) {
      _createdDepositRequestId = providedId;
      _effectiveStore.fetchOrderSummary(providedId);
    } else {
      _createCheckoutAndLoadSummary();
    }
  }

  /// Constrói o [CheckoutRequest] a partir dos items do carrinho.
  CheckoutRequest _buildCheckoutRequest() {
    final items = widget.items ?? const <CartItem>[];
    final cart = items
        .map(
          (item) => CalculateItem(
            serviceId: item.service.id ?? '',
            value: item.service.price ?? 0,
            quantity: item.quantity,
          ),
        )
        .toList();
    final totalValue = items.fold<double>(
      0,
      (sum, item) => sum + (item.service.price ?? 0) * item.quantity,
    );

    return CheckoutRequest(
      cart: cart,
      paymentMethod: 'generic',
      totalValue: totalValue,
    );
  }

  /// Cria o checkout no backend (GENERIC + PENDING) e carrega o resumo do
  /// pedido usando o depositRequestId retornado.
  Future<void> _createCheckoutAndLoadSummary() async {
    _effectiveStore.setLoading(true);
    _effectiveStore.clearError();

    final request = _buildCheckoutRequest();
    final result = await CheckoutsService.instance.createCheckout(request);

    if (!mounted) return;

    if (!result.isSuccess || result.value?.depositRequestId == null) {
      _effectiveStore.setError(
        result.isSuccess
            ? 'Não foi possível iniciar o checkout.'
            : result.error.toString(),
      );
      _effectiveStore.setLoading(false);
      return;
    }

    _createdDepositRequestId = result.value!.depositRequestId;
    await _effectiveStore.fetchOrderSummary(_createdDepositRequestId!);
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

    // Formatador oficial pra injetar no OrderSummaryCard
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    void notifyStatus(PaymentStatus status) {
      setState(() => _currentStatus = status);
      widget.onStatusChange?.call(status);
    }

    void syncControllerState(Future<void> Function() submitPayment) {
      final checkoutController = widget.controller;
      if (checkoutController == null) {
        return;
      }

      void applyState() {
        checkoutController._submitPayment = submitPayment;
        checkoutController.selectedMethod.value = effectiveStore.selectedMethod;
        checkoutController.hasSelectedMethod.value = _hasSelectedMethod;
        checkoutController.isLoading.value = effectiveStore.isLoading;
        checkoutController.hasGeneratedPix.value =
            effectiveStore.hasGeneratedPix;
      }

      // Evita "setState() called during build": quando chamado de dentro do
      // builder do Observer, adia a notificação dos ValueNotifiers pro fim
      // do frame atual em vez de disparar rebuilds síncronos em outras
      // subárvores (ex.: ValueListenableBuilder no CheckoutScreen).
      if (SchedulerBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        SchedulerBinding.instance.addPostFrameCallback((_) => applyState());
      } else {
        applyState();
      }
    }

    Future<void> handleMethodSelection(
      PaymentMethodType newMethod,
      Future<void> Function() submitPayment,
    ) async {
      if (!_hasSelectedMethod) {
        setState(() => _hasSelectedMethod = true);
      }

      effectiveStore.selectMethod(newMethod);
      syncControllerState(submitPayment);

      final depositRequestId =
          widget.depositRequestId ?? _createdDepositRequestId;
      if (depositRequestId == null) {
        syncControllerState(submitPayment);
        return;
      }

      if (newMethod != PaymentMethodType.pix) {
        effectiveStore.setFeeAmount(null);
        effectiveStore.setTotalAmount(effectiveStore.amount);
        syncControllerState(submitPayment);
        return;
      }

      await effectiveStore.fetchFeeAmount(
        depositRequestId,
        effectiveStore.amount,
        newMethod,
      );
      syncControllerState(submitPayment);
    }

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
        final depositRequestId =
            widget.depositRequestId ?? _createdDepositRequestId;
        if (depositRequestId == null) {
          showError(
            'Checkout ainda não está pronto. Tente novamente.',
            processPayment,
          );
          return;
        }

        final result = await effectiveStore.processPayment(
          depositRequestId: depositRequestId,
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
                  effectiveStore
                      .paymentId!, // Aqui pode ser o transactionId da Store
                  processPayment,
                  depositRequestId: depositRequestId,
                  pixQrCode: effectiveStore.pixQrCode,
                );
              },
            );
          }
          syncControllerState(processPayment);
        } else if (effectiveStore.isCardSelected) {
          final statusResponse = response as PaymentStatusResponse;

          switch (statusResponse.status) {
            case GatewayPaymentStatus.approved:
              handleSuccess(
                statusResponse.nsu ?? depositRequestId,
                processPayment,
                depositRequestId:
                    statusResponse.depositRequestId ?? depositRequestId,
                message: statusResponse.message,
              );
            case GatewayPaymentStatus.processing:
              // Pagamento assíncrono: aguarda a confirmação do gateway com o
              // mesmo esquema de polling do PIX.
              notifyStatus(PaymentStatus.waitingPayment);
              effectiveStore.startCardPollingWithBackoff(
                depositRequestId,
                onSuccess: () {
                  handleSuccess(
                    statusResponse.nsu ?? depositRequestId,
                    processPayment,
                    depositRequestId:
                        statusResponse.depositRequestId ?? depositRequestId,
                  );
                },
              );
              syncControllerState(processPayment);
            case GatewayPaymentStatus.declined:
            case GatewayPaymentStatus.failed:
            case GatewayPaymentStatus.cancelled:
              showError(
                statusResponse.message ?? 'Pagamento com cartão não aprovado.',
                processPayment,
              );
          }
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
          return widget.loadingWidget ??
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Aguardando processamento do pagamento...'),
                    ],
                  ),
                ),
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
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 72,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Pagamento realizado com sucesso!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
            message: 'Pagamento realizado com sucesso!',
          );
        }

        // 3. Tela de Erro Amigável (Fim do fluxo ruim)
        if (_currentStatus == PaymentStatus.failed || effectiveStore.hasError) {
          if (effectiveStore.hasError) {
            return CheckoutErrorState(
              message: effectiveStore.errorMessage!,
              onRetry: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              // onRetry: () => { effectiveStore.clearError(), effectiveStore.clearPixData() },
            );
          }
        }

        // 4. Tela de Espera do Cartão (polling do gateway em andamento)
        if (_currentStatus == PaymentStatus.waitingPayment &&
            effectiveStore.isCardSelected) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Aguardando processamento do pagamento...'),
                ],
              ),
            ),
          );
        }

        // 5. Fluxo Normal de Checkout (Formulário)
        final method = effectiveStore.selectedMethod;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          // Em telas largas (web/desktop) o conteúdo não estica: fica
          // centralizado com uma largura máxima confortável de leitura
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OrderSummaryCard(
                    items: effectiveStore.items
                        .map(
                          (item) => CartItem(
                            service: Service(
                              name: item.name,
                              price: item.price,
                            ),
                            quantity: item.quantity,
                          ),
                        )
                        .toList(),
                    subtotalValue: effectiveStore.amount,
                    feeAmount: effectiveStore.feeAmount,
                    totalValue: effectiveStore.totalAmount,
                    currencyFormat: currencyFormat,
                  ),
                  const SizedBox(height: 24),

                  // Container que envelopa o pagamento
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).cardColor,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.46),
                          blurRadius: 7,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecione o Método de Pagamento',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),

                        PaymentMethodSelector(
                          selectedMethod: _hasSelectedMethod ? method : null,
                          onChanged: (newMethod) async {
                            await handleMethodSelection(
                              newMethod,
                              processPayment,
                            );
                          },
                          showPix: widget.showPix,
                          showCard: widget.showCard,
                        ),
                        const SizedBox(height: 24),

                        // Enquanto o usuário não escolher um método, mostra um
                        // aviso chamativo no lugar do formulário de pagamento
                        if (!_hasSelectedMethod)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF10C484,
                              ).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(
                                  0xFF10C484,
                                ).withValues(alpha: 0.4),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.touch_app_outlined,
                                  color: Color(0xFF10C484),
                                  size: 28,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Escolha acima como você prefere pagar para '
                                    'continuar com o pedido.',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
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
                              onCardHolderChanged:
                                  effectiveStore.updateCardHolderName,
                              onCardNumberChanged:
                                  effectiveStore.updateCardNumber,
                              onExpiryChanged: effectiveStore.updateExpiryDate,
                              onSecurityCodeChanged:
                                  effectiveStore.updateSecurityCode,
                              taxId: effectiveStore.taxId,
                              onTaxIdChanged: effectiveStore.updateTaxId,
                            ),
                          },
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (widget.showSubmitButton &&
                      _hasSelectedMethod &&
                      !(method == PaymentMethodType.pix &&
                          effectiveStore.hasGeneratedPix))
                    ElevatedButton(
                      onPressed: processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF10C484,
                        ), // Mesmo verde dos preços
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        method == PaymentMethodType.card
                            ? 'Pagar Agora'
                            : 'Gerar Pagamento',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  StatusBanner(status: _currentStatus),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Backend fake usado apenas em testes/demos locais, habilitado via
/// [CheckoutWidget.debugUseMockBackend].
class MockBackendSpaService {
  static String createOrderAndGetDepositId() {
    return '7f867680-df5f-40c0-b21c-7d569d3ef010';
  }
}
