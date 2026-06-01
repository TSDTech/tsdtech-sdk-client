import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';

class PixPaymentView extends StatelessWidget {
  final String? qrCode;
  final String? copyPasteCode;
  final String? expiresAt; 

  const PixPaymentView({
    super.key, 
    this.qrCode, 
    this.copyPasteCode,
    this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF10C484);

    void showMessage(String message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    // 1. Estado Inicial (Antes de gerar o PIX)
    if (qrCode == null || qrCode!.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7), // Fundo cinza padrão
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.pix_outlined, color: Colors.black54),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'O pagamento será processado via PIX instantâneo. Clique abaixo para gerar o código.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 2. Estado com o PIX gerado
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixDisplay(
          pixData: PixData(
            qrCode: qrCode!,
            copyPasteCode: copyPasteCode ?? qrCode!,
          ),
          expiresAt: expiresAt != null ? DateTime.parse(expiresAt!) : DateTime.now().add(const Duration(minutes: 25)),
          onCopied: () => showMessage('Código PIX copiado.'),
        ),
        
        const SizedBox(height: 24),

        // 3. Indicador de "Aguardando pagamento" refatorado
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F5F7), // Fundo cinza padrão
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200), // Borda bem sutil
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(brandGreen), // Spinner na cor da marca
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Aguardando confirmação...',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}