import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/src/ui/checkout/checkout.dart';
// import 'package:tsdtech_client_sdk/src/ui/components/demo/demo_components.dart';
import 'package:tsdtech_client_sdk/src/ui/config/tsdtech_ui_config.dart';

class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key, required this.status});
  
  final PaymentStatus? status;

  @override
  Widget build(BuildContext context) {
    final theme = TsdtechUiConfig.instance.theme;
    
    // 1. Estado Nulo (Aguardando Ação) renderizado com o padrão cinza claro
    if (status == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7), // Mesmo fundo cinza dos itens do carrinho
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.black54),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status do Checkout',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Aguardando ação.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 2. Cores dinâmicas baseadas no tema original
    final map = switch (status!) {
      PaymentStatus.processing => ('Processando', theme.warningColor),
      PaymentStatus.waitingPayment => (
        'Aguardando pagamento',
        theme.accentColor,
      ),
      PaymentStatus.success => ('Concluído', theme.successColor),
      PaymentStatus.failed => ('Falhou', theme.errorColor),
    };

    // 3. Estado de Status Ativo (flat e sem borda para ficar mais moderno)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: map.$2.withValues(alpha: 0.1), // Fundo suave transparente da respectiva cor
        borderRadius: BorderRadius.circular(8), // Borda de 8px acompanhando o resto
        // Borda removida intencionalmente para o visual flat (sem linha demarcando)
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: map.$2),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Status atual: ${map.$1}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: map.$2, // A cor do texto acompanha a cor do ícone
              ),
            ),
          ),
        ],
      ),
    );
  }
}