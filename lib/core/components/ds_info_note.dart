import 'package:flutter/material.dart';

/// Container de informação com ícone e texto
class DsInfoNote extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;

  const DsInfoNote({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor ?? Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.info_outline,
            color: iconColor ?? Colors.blue[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: textColor ?? Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
