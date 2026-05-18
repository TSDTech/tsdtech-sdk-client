import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

class CheckoutWidget extends StatelessWidget {
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
  final CheckoutStore store;

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

    String buildEncryptedCardData() {
      final cardData = CardPaymentData(
        cardHolderName: effectiveStore.cardHolderName.trim(),
        cardNumber: effectiveStore.cardNumber.trim(),
        cardExpiryDate: toBackendCardExpiry(effectiveStore.expiryDate.trim()),
        securityCode: effectiveStore.securityCode.trim(),
      );
      return CardEncryptor.encrypt(gatewayPublicKey, cardData);
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

    void startPixPolling(String paymentId, Future<void> Function() submitPayment) {
      effectiveStore.startPixPolling(
        Timer.periodic(const Duration(seconds: 5), (timer) async {
          try {
            final statusResult = await CheckoutsService.instance.getPixStatus(paymentId);
            if (!statusResult.isSuccess) return;

            final status = statusResult.value?.toLowerCase() ?? '';
            if (status == 'paid' || status == 'completed' || status == 'success') {
              timer.cancel();
              handleSuccess(
                paymentId,
                submitPayment,
                pixQrCode: effectiveStore.pixQrCode,
              );
            }
          } catch (_) {
            // Ignored: manter polling
          }
        }),
      );
    }

    Future<void> processPayment() async {
      if (effectiveStore.isCardSelected) {
        if (!effectiveStore.validateCardForm()) return;
        if (gatewayPublicKey.trim().isEmpty) {
          showError('A chave pública do gateway não pode ficar vazia.', processPayment);
          return;
        }
      }

      effectiveStore.setLoading(true);
      syncControllerState(processPayment);
      effectiveStore.clearError();
      notifyStatus(PaymentStatus.processing);

      try {
        final checkoutRequest = CheckoutRequest(
          cart: buildCalculateItems(),
          paymentMethod: methodToApiString(effectiveStore.selectedMethod),
          totalValue: totalValue,
          encryptedCard: effectiveStore.isCardSelected
              ? buildEncryptedCardData()
              : null,
        );

        final result = await CheckoutsService.instance.createCheckout(checkoutRequest);

        if (!result.isSuccess) {
          showError(result.error.toString(), processPayment);
          return;
        }

        final response = result.value!;

        if (effectiveStore.isPixSelected) {
          effectiveStore.setPixData(
            paymentId: response.paymentId,
            qrCode: response.pix?.qrCode,
            copyPasteCode: response.pix?.copyPasteCode,
          );
          notifyStatus(PaymentStatus.waitingPayment);

          if (effectiveStore.paymentId != null) {
            startPixPolling(effectiveStore.paymentId!, processPayment);
          }
          syncControllerState(processPayment);
        } else if (effectiveStore.isCardSelected) {
          handleSuccess(
            response.paymentId ??
                response.depositRequestId ??
                'card_${DateTime.now().millisecondsSinceEpoch}',
            processPayment,
            depositRequestId: response.depositRequestId,
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
                ),
            },
            const SizedBox(height: 24),
            if (showSubmitButton &&
                !(method == PaymentMethodType.pix && effectiveStore.hasGeneratedPix))
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
          ],
        );
      },
    );
  }
}