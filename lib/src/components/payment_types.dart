enum PaymentMethodType { pix, card, bill }

enum PaymentStatus { processing, waitingPayment, success, failed }

class PaymentResult {
  final String transactionId;
  final PaymentMethodType method;
  final PaymentStatus status;
  final String? pixQrCode;
  final String? billBarcode;
  final String? billUrl;
  final String? depositRequestId;
  final String? message;

  PaymentResult({
    required this.transactionId,
    required this.method,
    required this.status,
    this.pixQrCode,
    this.billBarcode,
    this.billUrl,
    this.depositRequestId,
    this.message,
  });
}
