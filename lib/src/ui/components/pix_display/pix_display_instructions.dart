import 'package:flutter/material.dart';

import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';

class PixInstructions extends StatelessWidget {
  const PixInstructions({super.key, required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: TsdtechColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              'Como pagar',
              style: TsdtechTextStyles.titleSmall.copyWith(
                color: TsdtechColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...steps.indexed.map(
          (entry) => _InstructionStep(
            number: entry.$1 + 1,
            text: entry.$2,
          ),
        ),
      ],
    );
  }
}

class _InstructionStep extends StatelessWidget {
  const _InstructionStep({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: TsdtechColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: TsdtechTextStyles.labelSmall.copyWith(
                color: TsdtechColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TsdtechTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
