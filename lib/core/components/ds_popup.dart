import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';

class DsPopup extends StatelessWidget {
  final String message;
  final Color? iconColor;
  final Color? textColor;
  final IconData? button_icon;
  final List<Widget>? actions;
  final Widget? child; // <- novo parâmetro opcional

  const DsPopup({
    super.key,
    required this.message,
    this.button_icon,
    this.iconColor,
    this.textColor,
    this.actions,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      contentPadding: const EdgeInsets.fromLTRB(22.25, 22.25, 22.25, 22.25),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (child != null) ...[
            child!,
            const SizedBox(height: 16),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (button_icon != null) ...[
                Icon(
                  button_icon,
                  color: iconColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: DsText(
                  text: message,
                  variant: DsTextVariant.baseBold,
                  color: textColor,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: actions,
    );
  }

  static void showError(BuildContext context, String s) {}
}
