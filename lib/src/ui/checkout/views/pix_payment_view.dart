import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

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
    void showMessage(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
    // Validação: Se não tem qrCode, mostra o texto inicial (igualzinho você fez)
    if (qrCode == null || qrCode!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'O pagamento será processado via PIX instantâneo. Clique abaixo para gerar o código.',
          textAlign: TextAlign.center,
        ),
      );
    }

    // Se tem qrCode, mostramos usando o estilo e as funções do PixDisplay
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixDisplay(
          // Instanciamos o PixData. Se o copyPasteCode for nulo, fazemos um fallback pro próprio qrCode
          pixData: PixData(
            qrCode: qrCode!,
            copyPasteCode: copyPasteCode ?? qrCode!,
          ),
          expiresAt: expiresAt != null ? DateTime.parse(expiresAt!) : DateTime.now().add(const Duration(minutes: 25)),
          onCopied: () => showMessage('Código PIX copiado.'),
        ),
        
        const SizedBox(height: 32),
        
        // Mantemos o seu indicador de "Aguardando pagamento" no final da tela
        const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Aguardando confirmação do pagamento...',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey, // Uma corzinha pra ficar mais elegante
              ),
            ),
          ],
        ),
      ],
    );
  }
}