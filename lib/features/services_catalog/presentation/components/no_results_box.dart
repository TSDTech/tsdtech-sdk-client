import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';

class NoResultsBox extends StatelessWidget {
  final VoidCallback onShowAll;
  const NoResultsBox({super.key, required this.onShowAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 12, bottom: 24),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 0),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 32, color: Colors.grey),
              SizedBox(height: 8),
              DsText(
                text: 'Nenhum serviço encontrado para esta categoria.',
                variant: DsTextVariant.baseBold,
                color: Colors.black87,
              ),
              SizedBox(height: 6),
              DsText(
                text:
                    'Você pode alterar o filtro ou visualizar todos os serviços disponíveis.',
                variant: DsTextVariant.small,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 240,
          child: ElevatedButton(
            onPressed: onShowAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const DsText(
              text: 'Ver todos os serviços',
              variant: DsTextVariant.baseBold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
