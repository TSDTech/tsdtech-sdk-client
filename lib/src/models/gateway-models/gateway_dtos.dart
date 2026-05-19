class PublicKeyResponse {
  final String keyId;
  final String publicKey;

  PublicKeyResponse({required this.keyId, required this.publicKey});

  factory PublicKeyResponse.fromJson(Map<String, dynamic> json) {
    return PublicKeyResponse(
      keyId: json['keyId'] ?? '',
      publicKey: json['publicKey'] ?? '',
    );
  }
}

class CardPaymentRequest {
  final String depositRequestId;
  final String encryptedCardData;
  final String keyId;

  CardPaymentRequest({
    required this.depositRequestId,
    required this.encryptedCardData,
    required this.keyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'depositRequestId': depositRequestId,
      'encryptedCardData': encryptedCardData,
      'keyId': keyId,
    };
  }
}

class PaymentStatusResponse {
  final String depositRequestId;
  final String status;

  PaymentStatusResponse({required this.depositRequestId, required this.status});

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      depositRequestId: json['depositRequestId'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
