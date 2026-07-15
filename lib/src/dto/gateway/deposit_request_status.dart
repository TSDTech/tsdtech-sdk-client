import 'gateway_payment_status.dart';

/// Status de um DepositRequest retornado pelos endpoints públicos do
/// back-ms-subaccount (ex.: GET /deposit-request/public/status-pix/:id).
///
/// Difere do [GatewayPaymentStatus] usado nas respostas de pagamento do SDK;
/// use [toGatewayPaymentStatus] para converter.
enum DepositRequestStatus {
  pending('PENDING'),
  waitingPayment('WAITING_PAYMENT'),
  paid('PAID'),
  cancelled('CANCELLED'),
  expired('EXPIRED');

  final String value;
  const DepositRequestStatus(this.value);

  /// Converte o valor cru vindo do backend. Retorna null para valores
  /// desconhecidos.
  static DepositRequestStatus? fromValue(String? value) {
    for (final status in values) {
      if (status.value == value) return status;
    }
    return null;
  }

  GatewayPaymentStatus toGatewayPaymentStatus() => switch (this) {
    paid => GatewayPaymentStatus.approved,
    pending || waitingPayment => GatewayPaymentStatus.processing,
    cancelled => GatewayPaymentStatus.cancelled,
    expired => GatewayPaymentStatus.failed,
  };
}
