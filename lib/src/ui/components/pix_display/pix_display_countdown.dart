import 'package:flutter/material.dart';

import '../../theme/tsdtech_colors.dart';
import '../../theme/tsdtech_text_styles.dart';

class PixCountdown extends StatelessWidget {
  const PixCountdown({
    super.key,
    required this.expired,
    required this.timerColor,
    required this.formattedRemaining,
  });

  final bool expired;
  final Color timerColor;
  final String formattedRemaining;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: expired
            ? const _StatusChip(
                key: ValueKey('expired'),
                icon: Icons.timer_off_outlined,
                label: 'Código expirado',
                color: TsdtechColors.error,
                backgroundColor: TsdtechColors.errorLight,
              )
            : Container(
                key: const ValueKey('countdown'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: timerColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: timerColor.withAlpha(80)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 18, color: timerColor),
                    const SizedBox(width: 8),
                    Text(
                      'Expira em ',
                      style: TsdtechTextStyles.bodySmall.copyWith(
                        color: timerColor,
                      ),
                    ),
                    Text(
                      formattedRemaining,
                      style: TsdtechTextStyles.titleSmall.copyWith(
                        color: timerColor,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TsdtechTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
