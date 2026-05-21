import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tsdtech_client_sdk/src/ui/components/demo/demo_components.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
// Lá nos imports (topo do arquivo):
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart' as cardPayment;

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

class CheckoutWidget extends StatelessWidget {
  final List<CartItem> items;
  final String administratorId;
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
  final CheckoutStore store;

  const CheckoutWidget({
    super.key,
    required this.items,
    required this.administratorId,
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
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStore = store;

    void notifyStatus(PaymentStatus status) {
      onStatusChange?.call(status);
    }

    void syncControllerState(Future<void> Function() submitPayment) {
      final checkoutController = controller;
      if (checkoutController == null) {
        return;
      }

      checkoutController._submitPayment = submitPayment;
      checkoutController.selectedMethod.value = effectiveStore.selectedMethod;
      checkoutController.isLoading.value = effectiveStore.isLoading;
      checkoutController.hasGeneratedPix.value = effectiveStore.hasGeneratedPix;
    }

    List<CalculateItem> buildCalculateItems() {
      return items.map((item) {
        return CalculateItem(
          serviceId: item.service.id ?? '',
          value: item.service.price ?? 0.0,
          quantity: item.quantity,
        );
      }).toList();
    }

    final totalValue = items.fold<double>(0.0, (sum, item) {
      return sum + (item.service.price ?? 0.0) * item.quantity;
    });

    // Helper para formatar moeda de forma simples
    String formatCurrency(double value) {
      return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
    }

    String methodToApiString(PaymentMethodType method) {
      switch (method) {
        case PaymentMethodType.pix:
          return 'pix';
        case PaymentMethodType.card:
          return 'card';
      }
    }

    String toBackendCardExpiry(String value) {
      final parts = value.split('/');
      if (parts.length != 2) return '';
      final month = parts[0].padLeft(2, '0');
      final year = parts[1];
      return '20$year$month';
    }

    void showError(String message, Future<void> Function() submitPayment) {
      effectiveStore.setError(message);
      onError?.call(message);
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
      onSuccess?.call(result);
      syncControllerState(submitPayment);
    }

    void startPixPolling(
      String paymentId,
      Future<void> Function() submitPayment,
    ) {
      final pollingToken = effectiveStore.startPixPolling();

      Future<void> pollStatus() async {
        await Future.delayed(const Duration(seconds: 10));
        if (!effectiveStore.isPixPollingActive(pollingToken)) {
          return;
        }

        try {
          final statusResult = await CheckoutsService.instance.getMockPixStatus(
            paymentId,
          );
          if (!effectiveStore.isPixPollingActive(pollingToken)) {
            return;
          }
          if (!statusResult.isSuccess) {
            unawaited(pollStatus());
            return;
          }

          final status = statusResult.value?.toLowerCase() ?? '';
          if (status == PaymentStatus.success.name) {
            effectiveStore.cancelPixPolling();
            handleSuccess(
              paymentId,
              submitPayment,
              pixQrCode: effectiveStore.pixQrCode,
            );
            return;
          }
        } catch (_) {
          effectiveStore.errorMessage = 'Erro ao verificar status do pagamento.';
        }

        if (effectiveStore.isPixPollingActive(pollingToken)) {
          unawaited(pollStatus());
        }
      }

      unawaited(pollStatus());
    }

    Future<void> processPayment() async {
      // Validação restaurada exatamente como você pediu
      if (effectiveStore.isCardSelected) {
        if (!effectiveStore.validateCardForm()) return;
        // if ((gatewayPublicKey ?? '').trim().isEmpty) {
        //   showError(
        //     'A chave pública do gateway não pode ficar vazia.',
        //     processPayment,
        //   );
        //   return;
        // }
      } 

      effectiveStore.setLoading(true);
      syncControllerState(processPayment);
      effectiveStore.clearError();
      notifyStatus(PaymentStatus.processing);

      try {
        // Chamada do Mock para obter o depositRequestId
        final depositRequestId = await MockBackendSpaService.createOrderAndGetDepositId();

        final orchestrator = TsdtechClient.instance.orchestrator!;  

        final dynamic result;

        if (effectiveStore.isCardSelected) {
          result = await orchestrator.payWithCard(
            CheckoutRequest(
              cart: buildCalculateItems(),
              paymentMethod: methodToApiString(effectiveStore.selectedMethod),
              totalValue: totalValue,
              depositRequestId: depositRequestId, // Passando o ID gerado pelo Mock
            ),
            cardPayment.CardPaymentData(
              cardHolderName: effectiveStore.cardHolderName.trim(),
              cardNumber: effectiveStore.cardNumber.trim(),
              cardExpiryDate: toBackendCardExpiry(effectiveStore.expiryDate.trim()),
              securityCode: effectiveStore.securityCode.trim(),
            ),
          );
        } else if (effectiveStore.isPixSelected) {
          // Passando o ID gerado pelo Mock em vez da string fixa
          result = await orchestrator.payWithPix(depositRequestId);
        } else {
          showError('Nenhum método de pagamento selecionado.', processPayment);
          return;
        }

        if (!result.isSuccess) {
          showError(result.error.toString(), processPayment);
          return;
        }

        final response = result.value!;

        if (effectiveStore.isPixSelected) {
          effectiveStore.setPixData(
            paymentId: response.id,
            qrCode: response.textQrCode,
            copyPasteCode: response.textQrCode,
          );
          notifyStatus(PaymentStatus.waitingPayment);

          if (effectiveStore.paymentId != null) {
            startPixPolling(effectiveStore.paymentId!, processPayment);
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

    return Observer(
      builder: (_) {
        syncControllerState(processPayment);
        if (effectiveStore.isLoading) {
          return CheckoutLoadingState(customLoading: loadingWidget);
        }

        if (effectiveStore.hasError) {
          return CheckoutErrorState(
            message: effectiveStore.errorMessage!,
            onRetry: processPayment,
            customError: errorWidget,
          );
        }

        final method = effectiveStore.selectedMethod;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            CartPreview(items: items, total: totalValue),
            const SizedBox(height: 24), 
            PaymentMethodSelector(
              selectedMethod: method,
              onChanged: (newMethod) {
                effectiveStore.selectMethod(newMethod);
                syncControllerState(processPayment);
              },
              showPix: showPix,
              showCard: showCard,
            ),
            const SizedBox(height: 24),
            switch (method) {
              PaymentMethodType.pix => PixPaymentView(
                qrCode: effectiveStore.pixQrCode,
                copyPasteCode: effectiveStore.pixCopyPasteCode,
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
            const SizedBox(height: 24),
            if (showSubmitButton &&
                !(method == PaymentMethodType.pix &&
                    effectiveStore.hasGeneratedPix))
              ElevatedButton(
                onPressed: processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                // Botão dinâmico: Pagar Agora (Cartão) ou Gerar Pagamento (Pix)
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

class MockBackendSpaService {
  // Simula a chamada POST /orders (Passos 2 a 8 do seu diagrama)
  static Future<String> createOrderAndGetDepositId() async {
    // Finge que o servidor tá processando regras de Split, chamando o Server SDK, etc.
    await Future.delayed(const Duration(seconds: 2)); 
    
    // Retorna o depositRequestId mockado gerado pelo "TSDTECH"
    return '88406839-b6d0-48c8-8778-168ef7762d17'; 
  }
}