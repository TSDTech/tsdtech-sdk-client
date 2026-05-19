import 'package:flutter/material.dart';

import '../ui/checkout/payment_types.dart';

class PaymentStatusScreen extends StatelessWidget {
  const PaymentStatusScreen({
    super.key,
    required this.paymentResult,
    this.onRetry,
    this.onBack,
  });

  final PaymentResult paymentResult;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  static MaterialPageRoute<void> route({
    required PaymentResult paymentResult,
    VoidCallback? onRetry,
    VoidCallback? onBack,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => PaymentStatusScreen(
        paymentResult: paymentResult,
        onRetry: onRetry,
        onBack: onBack,
      ),
      settings: const RouteSettings(name: 'payment_status_screen'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presentation = _StatusPresentation.fromPaymentResult(paymentResult);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status do pagamento'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: presentation.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          presentation.icon,
                          size: 36,
                          color: presentation.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        presentation.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        presentation.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Detalhes do pagamento',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(label: 'Status', value: presentation.label),
                      _DetailRow(
                        label: 'Transacao',
                        value: paymentResult.transactionId,
                      ),
                      _DetailRow(
                        label: 'Metodo',
                        value: _methodLabel(paymentResult.method),
                      ),
                      if (paymentResult.depositRequestId != null)
                        _DetailRow(
                          label: 'Deposito',
                          value: paymentResult.depositRequestId!,
                        ),
                      if (paymentResult.pixQrCode != null)
                        _DetailRow(
                          label: 'PIX',
                          value: paymentResult.pixQrCode!,
                        ),
                      if ((paymentResult.message ?? '').trim().isNotEmpty)
                        _DetailRow(
                          label: 'Mensagem',
                          value: paymentResult.message!.trim(),
                          isLast: true,
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  onBack?.call();
                  Navigator.of(context).maybePop();
                },
                child: const Text('Voltar'),
              ),
              if (presentation.canRetry) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _methodLabel(PaymentMethodType method) {
    switch (method) {
      case PaymentMethodType.pix:
        return 'PIX';
      case PaymentMethodType.card:
        return 'Cartao';
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _StatusPresentation {
  const _StatusPresentation({
    required this.title,
    required this.description,
    required this.label,
    required this.icon,
    required this.color,
    required this.canRetry,
  });

  final String title;
  final String description;
  final String label;
  final IconData icon;
  final Color color;
  final bool canRetry;

  factory _StatusPresentation.fromPaymentResult(PaymentResult paymentResult) {
    switch (paymentResult.status) {
      case PaymentStatus.processing:
        return const _StatusPresentation(
          title: 'Processando pagamento',
          description:
              'Seu pagamento esta sendo processado. Aguarde a confirmacao.',
          label: 'Processing',
          icon: Icons.sync_rounded,
          color: Colors.blue,
          canRetry: false,
        );
      case PaymentStatus.waitingPayment:
        return const _StatusPresentation(
          title: 'Pagamento pendente',
          description: 'O pagamento foi iniciado e ainda aguarda confirmacao.',
          label: 'Pending',
          icon: Icons.schedule_rounded,
          color: Colors.amber,
          canRetry: false,
        );
      case PaymentStatus.success:
        return const _StatusPresentation(
          title: 'Pagamento aprovado',
          description: 'Pagamento confirmado com sucesso.',
          label: 'Approved',
          icon: Icons.check_circle_outline_rounded,
          color: Colors.green,
          canRetry: false,
        );
      case PaymentStatus.failed:
        return const _StatusPresentation(
          title: 'Pagamento falhou',
          description: 'Nao foi possivel concluir o pagamento.',
          label: 'Failed',
          icon: Icons.error_outline_rounded,
          color: Colors.red,
          canRetry: true,
        );
    }
  }
}
