import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PixPaymentView extends StatelessWidget {
  final String? qrCode;
  final String? copyPasteCode;

  const PixPaymentView({super.key, this.qrCode, this.copyPasteCode});

  @override
  Widget build(BuildContext context) {
    if (qrCode != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Escaneie o QR Code abaixo:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: QrImageView(
              data: qrCode!,
              version: QrVersions.auto,
              size: 220,
              semanticsLabel: 'PIX QR Code',
            ),
          ),
          const SizedBox(height: 16),
          if (copyPasteCode != null)
            SelectableText(copyPasteCode!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
          const SizedBox(height: 8),
          const Text('Aguardando confirmação do pagamento...'),
        ],
      );
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'O pagamento será processado via PIX instantâneo. Clique abaixo para gerar o código.',
        textAlign: TextAlign.center,
      ),
    );
  }
}
