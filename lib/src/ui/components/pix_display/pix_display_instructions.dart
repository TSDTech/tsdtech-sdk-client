import 'package:flutter/material.dart';

class PixInstructions extends StatelessWidget {
  const PixInstructions({super.key, required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Agrupa as instruções num container com o mesmo fundo cinza do carrinho
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7), 
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Colors.black54,
              ),
              SizedBox(width: 8),
              Text(
                'Como pagar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.indexed.map(
            (entry) => _InstructionStep(number: entry.$1 + 1, text: entry.$2),
          ),
        ],
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  const _InstructionStep({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF10C484);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Círculo do número
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: brandGreen.withValues(alpha: 0.15), // Fundo verde suave
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: brandGreen, // Texto verde forte
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Texto da instrução
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black54, // Cinza escuro para leitura confortável
                fontSize: 13,
                height: 1.4, // Espaçamento entre linhas pra respirar melhor
              ),
            ),
          ),
        ],
      ),
    );
  }
}