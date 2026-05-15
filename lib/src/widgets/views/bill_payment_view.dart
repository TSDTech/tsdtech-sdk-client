import 'package:flutter/material.dart';

class BillPaymentView extends StatelessWidget {
  final String? barcode;
  final String? digitableLine;

  const BillPaymentView({
    super.key,
    this.barcode,
    this.digitableLine,
  });

  @override
  Widget build(BuildContext context) {
    if (barcode != null || digitableLine != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Boleto gerado com sucesso.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 16),
            if (digitableLine != null) ...[
              const Text('Linha digitável:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              SelectableText(digitableLine!),
              const SizedBox(height: 12),
            ],
            if (barcode != null) ...[
              const Text('Código de barras:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              SelectableText(barcode!),
            ],
          ],
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'Um boleto será gerado com vencimento em até 3 dias úteis.',
        textAlign: TextAlign.center,
      ),
    );
  }
}