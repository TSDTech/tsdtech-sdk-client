import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/src/models/checkout-mock/checkout_mock_response.model.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart' as checkout_request;

import '../checkout/payment_types.dart';

part 'checkout_store.g.dart';

class CheckoutStore = CheckoutStoreBase with _$CheckoutStore;

abstract class CheckoutStoreBase with Store {
  CheckoutStoreBase({PaymentMethodType initialMethod = PaymentMethodType.pix})
    : _initialMethod = initialMethod,
      selectedMethod = initialMethod;

  final PaymentMethodType _initialMethod;
  final GlobalKey<FormState> cardFormKey = GlobalKey<FormState>();
  
  // Variáveis para gerenciar o Polling antigo e o novo WebSocket
  Object? _pixPollingToken;
  WebSocketChannel? pixSocketChannel;

  CheckoutsService get _checkoutService => CheckoutsService.instance;

  @observable
  PaymentMethodType selectedMethod;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String? pixQrCode;

  @observable
  String? pixCopyPasteCode;

  @observable
  String? pixExpirationDate;

  @observable
  String? paymentId;

  @observable
  PaymentResult? paymentResult;

  @observable
  String cardHolderName = '';

  @observable
  String cardNumber = '';

  @observable
  String expiryDate = '';

  @observable
  String securityCode = '';

  @observable
  int cardFormVersion = 0;

  @observable
  String taxId = '';

  @computed
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  @computed
  bool get hasGeneratedPix => pixQrCode != null && pixQrCode!.isNotEmpty;

  @computed
  bool get isPixSelected => selectedMethod == PaymentMethodType.pix;

  @computed
  bool get isCardSelected => selectedMethod == PaymentMethodType.card;

  bool validateCardForm() => cardFormKey.currentState?.validate() ?? false;

  @action
  void updateCardHolderName(String value) => cardHolderName = value;

  @action
  void updateCardNumber(String value) => cardNumber = value;

  @action
  void updateExpiryDate(String value) => expiryDate = value;

  @action
  void updateSecurityCode(String value) => securityCode = value;

  @action
  void updateTaxId(String value) => taxId = value;  

  @action
  void resetCardForm() {
    cardFormKey.currentState?.reset();
    cardHolderName = '';
    cardNumber = '';
    expiryDate = '';
    securityCode = '';
    cardFormVersion++;
  }

  @action
  void selectMethod(PaymentMethodType method) {
    if (selectedMethod == method) {
      return;
    }

    selectedMethod = method;
    clearError();
    clearPixData();
    cancelPixPolling();
  }

  @action
  void setLoading(bool value) => isLoading = value;

  @action
  void setError(String? message) {
    errorMessage = message;
    if (message != null && message.isNotEmpty) {
      paymentResult = null;
    }
  }

  @action
  void clearError() => errorMessage = null;

  @action
  void setPixData({String? paymentId, String? qrCode, String? copyPasteCode, String? expirationDate}) {
    this.paymentId = paymentId;
    pixQrCode = qrCode;
    pixCopyPasteCode = copyPasteCode;
    pixExpirationDate = expirationDate;
  }

  @action
  void clearPixData() {
    paymentId = null;
    pixQrCode = null;
    pixCopyPasteCode = null;
    pixExpirationDate = null;
  }

  @action
  void setPaymentResult(PaymentResult? result) {
    paymentResult = result;
    if (result != null) {
      errorMessage = null;
    }
  }

  @action
  void reset() {
    selectedMethod = _initialMethod;
    isLoading = false;
    errorMessage = null;
    pixQrCode = null;
    pixCopyPasteCode = null;
    paymentId = null;
    paymentResult = null;
    cancelPixPolling();
    resetCardForm();
  }

  // ==========================================
  // LÓGICA CORE TRANSFERIDA DO WIDGET
  // ==========================================

  /// Formata a data de validade pro Gateway
  String _toBackendCardExpiry(String value) {
    final parts = value.split('/');
    if (parts.length != 2) return '';
    final month = parts[0].padLeft(2, '0');
    final year = parts[1];
    return '20$year$month';
  }

  /// Processa o pagamento delegando pro Orchestrator de acordo com o selectedMethod
  @action
  Future<ValueResult<dynamic>> processPayment({
    required String depositRequestId,
    required checkout_request.CheckoutRequest request,
  }) async {
    setLoading(true);
    clearError();

    try {
      final orchestrator = TsdtechClient.instance.orchestrator!;
      ValueResult<dynamic> result;

      if (isCardSelected) {
        if (!validateCardForm()) {
          setLoading(false);
          return ValueResult.failure('Formulário de cartão inválido.');
        }

        final cardData = checkout_request.CardPaymentData(
          cardHolderName: cardHolderName.trim(),
          cardNumber: cardNumber.trim(),
          cardExpiryDate: _toBackendCardExpiry(expiryDate.trim()),
          securityCode: securityCode.trim(),
        );

        result = await orchestrator.payWithCard(request, cardData);

      } else if (isPixSelected) {
        result = await orchestrator.payWithPix(depositRequestId);
        
        if (result.isSuccess) {
          final pixResponse = result.value as DepositPixResponse;
          setPixData(
            paymentId: pixResponse.id,
            qrCode: pixResponse.textQrCode,
            copyPasteCode: pixResponse.textQrCode,
            expirationDate: pixResponse.expirationDate,
          );
        }
      } else {
        result = ValueResult.failure('Nenhum método de pagamento selecionado.');
      }

      if (result.isError) {
        setError(result.error);
      }

      return result;
    } catch (e) {
      setError(e.toString());
      return ValueResult.failure(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // ==========================================
  // POLLING INTELIGENTE (Backoff & Timeout)
  // ==========================================

  @action
  // ==========================================
  // POLLING INTELIGENTE (Backoff + Expiration Date)
  // ==========================================

  @action
  void startPixPollingWithBackoff(String paymentId, {required VoidCallback onSuccess}) {
    cancelPixPolling(); // Garante que não tem dois loops concorrentes rodando
    
    final token = Object();
    _pixPollingToken = token;

    // 1. SE NÃO HOUVER DATA DE EXPIRAÇÃO, COLOCA UM TIMEOUT PADRÃO DE SEGURANÇA
    int calculatedMaxAttempts = 50; 

    if (pixExpirationDate != null) {
      try {
        final expiryTime = DateTime.parse(pixExpirationDate!);
        final now = DateTime.now();
        final totalDurationSeconds = expiryTime.difference(now).inSeconds;

        if (totalDurationSeconds <= 0) {
          // O PIX já nasceu morto ou o relógio tá dessincronizado
          setError('O tempo limite para o pagamento deste PIX expirou.');
          _checkoutService.notifyPixExpired(paymentId).catchError((_) {});
          return;
        }

        // 2. CALCULA QUANTAS TENTATIVAS CABEM DENTRO DO TEMPO RESTANTE (Simulando o Backoff)
        int remainingSeconds = totalDurationSeconds;
        int virtualAttempt = 0;
        
        while (remainingSeconds > 0) {
          virtualAttempt++;
          int nextDelay = 5;
          if (virtualAttempt > 5) nextDelay = 10;
          if (virtualAttempt > 15) nextDelay = 15;
          
          remainingSeconds -= nextDelay;
        }
        
        // Adiciona uma margem de segurança de 2 tentativas adicionais
        calculatedMaxAttempts = virtualAttempt + 2;
        
      } catch (_) {
        // Fallback caso o parse da string falhe
        calculatedMaxAttempts = 50;
      }
    }

    int attempt = 0;

    Future<void> pollStatus() async {
      // Verifica se o usuário mudou de aba, cancelou ou saiu do fluxo
      if (!isPixPollingActive(token)) return;

      // 🔥 CASO 1: VALIDAÇÃO PELO RELÓGIO (O tempo estourou na timeline)
      if (pixExpirationDate != null) {
        try {
          if (DateTime.now().isAfter(DateTime.parse(pixExpirationDate!))) {
            _encerrarPorTimeout(paymentId, token);
            return;
          }
        } catch (_) {}
      }

      attempt++;

      // 🔥 CASO 2: VALIDAÇÃO POR TENTATIVAS DINÂMICAS (Sincronizado com o tempo)
      if (attempt > calculatedMaxAttempts) {
        _encerrarPorTimeout(paymentId, token);
        return;
      }

      // DETERMINA O INTERVALO ATUAL DO BACKOFF
      int waitTimeSeconds = 5; 
      if (attempt > 5) waitTimeSeconds = 10;  
      if (attempt > 15) waitTimeSeconds = 15; 

      // Aguarda o intervalo antes da chamada de rede
      await Future.delayed(Duration(seconds: waitTimeSeconds));

      // Checa novamente após o delay
      if (!isPixPollingActive(token)) return;

      try {
        final statusResult = await _checkoutService.getPixStatus(paymentId);

        if (!isPixPollingActive(token)) return;

        if (statusResult.isSuccess) {
          final status = statusResult.value?.toLowerCase() ?? '';

          if (status == 'success') {
            cancelPixPolling();
            onSuccess(); // Sucesso, muda o widget para verde
            return;
          } else if (status == 'expired' || status == 'cancelled' || status == 'failed') {
            cancelPixPolling();
            setError('Pagamento PIX expirado ou cancelado.');
            return;
          }
        }
      } catch (e) {
        // Erros oscilantes de internet não quebram o loop, apenas aguardam a próxima rodada
      }

      // Continua o loop de forma recursiva
      if (isPixPollingActive(token)) {
        pollStatus();
      }
    }

    // Inicializa o primeiro disparo
    pollStatus();
  }

  /// Método auxiliar privado para centralizar a limpeza e notificação de cancelamento
  void _encerrarPorTimeout(String paymentId, Object currentToken) {
    if (!isPixPollingActive(currentToken)) return;
    
    cancelPixPolling();
    setError('O tempo limite para o pagamento deste PIX expirou.');
    
    // Dispara de forma assíncrona ("fire and forget") para avisar o seu backend
    _checkoutService.notifyPixExpired(paymentId).catchError((_) {});
  }

  @action
  void cancelPixPolling() {
    _pixPollingToken = null; // Isso quebra o loop automaticamente na próxima checagem
  }

  bool isPixPollingActive(Object token) {
    return identical(_pixPollingToken, token);
  }

  void dispose() {
    cancelPixPolling();
  }
}