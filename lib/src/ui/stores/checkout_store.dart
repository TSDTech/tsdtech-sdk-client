import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:tsdtech_client_sdk/models/deposit-request/deposit_request_fee.model.dart';
import 'package:tsdtech_client_sdk/models/deposit-request/deposit_request_summary.model.dart';
import 'package:tsdtech_client_sdk/models/deposit-request/deposit_request_summary_item.model.dart';
import 'package:tsdtech_client_sdk/src/dto/gateway/gateway_payment_status.dart';
import 'package:tsdtech_client_sdk/src/models/checkout/deposit_pix_response.model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart'
    as checkout_request;

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
  double? feeAmount;

  @observable
  String securityCode = '';

  @observable
  int cardFormVersion = 0;

  @observable
  String taxId = '';

  @observable
  double amount = 0;

  @observable
  double totalAmount = 0;

  @observable
  ObservableList<DepositRequestItemSummary> items =
      ObservableList<DepositRequestItemSummary>();

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
  void setPixData({
    String? paymentId,
    String? qrCode,
    String? copyPasteCode,
    String? expirationDate,
  }) {
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
  void setAmount(double value) => amount = value;

  @action
  void setFeeAmount(double? value) => feeAmount = value;

  @action
  void setTotalAmount(double value) => totalAmount = value;

  @action
  void setItems(List<DepositRequestItemSummary> newItems) {
    items.clear();
    items.addAll(newItems);
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
    feeAmount = null;
    amount = 0;
    totalAmount = 0;
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
    checkout_request.CheckoutRequest? request,
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
          taxId: taxId.trim(),
        );

        // Com um deposit request já criado, espelha o fluxo do PIX:
        // converte o deposit para cartão (createDepositCard) e em seguida
        // executa o pagamento no gateway (fetch key + encrypt + send).
        if (request != null) {
          result = await orchestrator.payWithCard(request, cardData);
        } else {
          result = await orchestrator.payWithCardDeposit(
            depositRequestId,
            cardData,
          );
        }
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

  @action
  Future<ValueResult<DepositRequestSummaryResponse>> fetchOrderSummary(
    String depositRequestId,
  ) async {
    setLoading(true);
    clearError();

    try {
      final result = await _checkoutService.getOrderSummary(depositRequestId);
      if (result.isError) {
        setError(result.error);
        return result;
      }

      final summary = result.value;
      if (summary == null) {
        setError('Resumo do pedido indisponível.');
        return ValueResult.failure('Resumo do pedido indisponível.');
      }

      setItems(summary.itemsSummary);
      setAmount(summary.amount);
      setFeeAmount(null);
      setTotalAmount(summary.amount);
      return result;
    } catch (e) {
      setError(e.toString());
      return ValueResult.failure(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<ValueResult<DepositRequestFeeResponse>> fetchFeeAmount(
    String depositRequestId,
    double amount,
    PaymentMethodType selectedMethod,
  ) async {
    setLoading(true);
    clearError();

    try {
      final result = await _checkoutService.getDepositRequestFee(
        depositRequestId,
        selectedMethod,
      );
      if (result.isError) {
        setError(result.error);
        return result;
      }

      final feeResponse = result.value;
      if (feeResponse == null) {
        setError('Valor da taxa indisponível.');
        return ValueResult.failure('Valor da taxa indisponível.');
      }

      final currentFee = feeResponse.feeAmount ?? 0;
      setFeeAmount(currentFee);
      setTotalAmount(amount + currentFee);
      return result;
    } catch (e) {
      setError(e.toString());
      return ValueResult.failure(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // ==========================================
  // POLLING INTELIGENTE (Backoff Dinâmico & Expirador Casado)
  // ==========================================

  @action
  void startPixPollingWithBackoff(
    String paymentId, {
    required VoidCallback onSuccess,
  }) {
    cancelPixPolling(); // Garante que não existam dois loops concorrentes rodando

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
          // O PIX já nasceu morto ou o relógio está dessincronizado
          setError('O tempo limite para o pagamento deste PIX expirou.');
          _checkoutService.notifyPixExpired(paymentId).catchError((error) {
            debugPrint('Erro ao notificar expiração do PIX: $error');
            return ValueResult<String>.failure(error.toString());
          });
          return;
        }

        // 2. CALCULA MATEMATICAMENTE QUANTAS TENTATIVAS CABEM NO TEMPO RESTANTE
        int remainingSeconds = totalDurationSeconds;
        int virtualAttempt = 0;

        while (remainingSeconds > 0) {
          virtualAttempt++;
          int nextDelay = 5;
          if (virtualAttempt > 5) nextDelay = 10;
          if (virtualAttempt > 15) nextDelay = 15;

          remainingSeconds -= nextDelay;
        }

        // Adiciona uma pequena margem de segurança de 2 tentativas adicionais
        calculatedMaxAttempts = virtualAttempt + 2;
      } catch (_) {
        calculatedMaxAttempts = 50;
      }
    }

    int attempt = 0;

    Future<void> pollStatus() async {
      // Verifica se o usuário mudou de aba, cancelou ou saiu do fluxo
      if (!isPixPollingActive(token)) return;

      // 3. PEGA OS SEGUNDOS REAIS RESTANTES ANTES DE APLICAR O DELAY
      int remainingSeconds = 9999;

      if (pixExpirationDate != null) {
        try {
          final expiryTime = DateTime.parse(pixExpirationDate!);
          final now = DateTime.now();
          remainingSeconds = expiryTime.difference(now).inSeconds;

          // Se bateu ou estourou o tempo, encerra imediatamente
          if (remainingSeconds <= 0) {
            _encerrarPorTimeout(paymentId, token);
            return;
          }
        } catch (_) {}
      }

      attempt++;

      // VALIDAÇÃO POR LIMITE DINÂMICO DE TENTATIVAS
      if (attempt > calculatedMaxAttempts) {
        _encerrarPorTimeout(paymentId, token);
        return;
      }

      // DETERMINA O INTERVALO ATUAL SEGUINDO O BACKOFF
      int backoffWaitTime = 5;
      if (attempt > 5) backoffWaitTime = 10;
      if (attempt > 15) backoffWaitTime = 15;

      // 🔥 O PULO DO GATO: Se o tempo restante for menor que o backoff,
      // o app espera apenas o tempo exato que falta para o PIX expirar!
      final actualWaitTime = (remainingSeconds < backoffWaitTime)
          ? remainingSeconds
          : backoffWaitTime;

      // Aguarda o intervalo exato calculado
      await Future.delayed(Duration(seconds: actualWaitTime));

      // Checa novamente após sair do delay
      if (!isPixPollingActive(token)) return;

      try {
        // Bate na API pra checar se já mudou o status
        final statusResult = await _checkoutService.getPixStatus(paymentId);

        if (!isPixPollingActive(token)) return;

        if (statusResult.isSuccess) {
          final status = statusResult.value?.toLowerCase() ?? '';

          if (status == 'success' || status == 'paid' || status == 'approved') {
            cancelPixPolling();
            onSuccess(); // Sucesso, muda o widget para verde e fecha a conta
            return;
          } else if (status == 'expired' ||
              status == 'cancelled' ||
              status == 'failed') {
            cancelPixPolling();
            setError('Pagamento PIX expirado ou cancelado.');
            return;
          }
        }
      } catch (e) {
        // Erros oscilantes de rede ou internet piscando não quebram o fluxo,
        // apenas deixam agendar a próxima rodada
      }

      // 4. RECURSIVIDADE COERENTE
      if (isPixPollingActive(token)) {
        // Se aplicamos uma espera curta final, o tempo provavelmente zerou agora.
        // Forçamos uma checagem rápida no relógio antes de disparar a próxima chamada de rede à toa.
        if (pixExpirationDate != null) {
          try {
            if (DateTime.now().isAfter(DateTime.parse(pixExpirationDate!))) {
              _encerrarPorTimeout(paymentId, token);
              return;
            }
          } catch (_) {}
        }

        await pollStatus();
      }
    }

    // Inicializa o primeiro disparo
    pollStatus();
  }

  /// Polling do status do pagamento com cartão, espelhando o do PIX.
  ///
  /// Usado quando o gateway retorna `processing`: consulta
  /// [CheckoutsService.getCardPaymentStatus] com o mesmo backoff do PIX
  /// (5s → 10s → 15s) até aprovar, falhar ou estourar o limite de tentativas.
  /// Compartilha o token de polling com o PIX, então [cancelPixPolling]
  /// (chamado em [selectMethod], [reset] e [dispose]) também encerra este loop.
  @action
  void startCardPollingWithBackoff(
    String depositRequestId, {
    required VoidCallback onSuccess,
  }) {
    cancelPixPolling(); // Garante que não existam dois loops concorrentes rodando

    final token = Object();
    _pixPollingToken = token;

    // Cartão não tem data de expiração como o PIX: usa o teto padrão de
    // tentativas (~10 min com o backoff completo).
    const maxAttempts = 50;
    int attempt = 0;

    Future<void> pollStatus() async {
      if (!isPixPollingActive(token)) return;

      attempt++;

      if (attempt > maxAttempts) {
        cancelPixPolling();
        setError(
          'O tempo limite para confirmar o pagamento com cartão expirou.',
        );
        return;
      }

      // Mesmo backoff dinâmico do PIX
      int backoffWaitTime = 5;
      if (attempt > 5) backoffWaitTime = 10;
      if (attempt > 15) backoffWaitTime = 15;

      await Future.delayed(Duration(seconds: backoffWaitTime));

      if (!isPixPollingActive(token)) return;

      try {
        final statusResult = await _checkoutService.getCardPaymentStatus(
          depositRequestId,
        );

        if (!isPixPollingActive(token)) return;

        if (statusResult.isSuccess && statusResult.value != null) {
          final response = statusResult.value!;

          switch (response.status) {
            case GatewayPaymentStatus.approved:
              cancelPixPolling();
              onSuccess();
              return;
            case GatewayPaymentStatus.declined:
            case GatewayPaymentStatus.failed:
            case GatewayPaymentStatus.cancelled:
              cancelPixPolling();
              setError(
                response.message ?? 'Pagamento com cartão não aprovado.',
              );
              return;
            case GatewayPaymentStatus.processing:
              break; // Continua aguardando a próxima rodada
          }
        }
      } catch (e) {
        // Erros oscilantes de rede não quebram o fluxo,
        // apenas deixam agendar a próxima rodada
      }

      if (isPixPollingActive(token)) {
        await pollStatus();
      }
    }

    pollStatus();
  }

  /// Método auxiliar privado para centralizar a limpeza e notificação de cancelamento
  void _encerrarPorTimeout(String paymentId, Object currentToken) {
    if (!isPixPollingActive(currentToken)) return;

    cancelPixPolling();
    setError('O tempo limite para o pagamento deste PIX expirou.');

    // Dispara de forma assíncrona ("fire and forget") para avisar o seu backend
    // Adicionado tipo genérico explícito <String> exigido pelo linter no catchError
    _checkoutService.notifyPixExpired(paymentId).catchError((error) {
      debugPrint('Erro ao notificar expiração do PIX: $error');
      return ValueResult<String>.failure(error.toString());
    });
  }

  @action
  void cancelPixPolling() {
    _pixPollingToken =
        null; // Isso quebra o loop automaticamente na próxima checagem
  }

  bool isPixPollingActive(Object token) {
    return identical(_pixPollingToken, token);
  }

  void dispose() {
    cancelPixPolling();
  }
}
