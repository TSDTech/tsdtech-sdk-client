import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';

enum DsButtonVariant {
  primary,
  secondary,
  elevated,
  primaryTransaction,
  elevatedTransaction,
  primarySignUp,
  acceptTerms,
  elevatedSignUp,
  signUp,
  disabled
}

class DsButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? width;
  final double? height;
  final DsButtonVariant variant;

  const DsButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height = 42,
    this.variant = DsButtonVariant.primary,
  });

  static final Map<DsButtonVariant, ButtonStyle> _styles = {
    DsButtonVariant.primary: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 14,
        fontFamily: 'Segoe UI Symbol',
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      ),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
      backgroundColor: const Color.fromRGBO(0, 87, 168, 1),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    DsButtonVariant.secondary: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 14,
        fontFamily: 'Segoe UI Symbol',
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      ),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      foregroundColor: const Color.fromRGBO(55, 65, 81, 1),
      side: const BorderSide(color: Color.fromRGBO(209, 213, 219, 1), width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    DsButtonVariant.elevated: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 14,
        fontFamily: 'Segoe UI Symbol',
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      ),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      foregroundColor: const Color.fromRGBO(55, 65, 81, 1),
      side: const BorderSide(color: Color.fromRGBO(209, 213, 219, 1), width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    DsButtonVariant.disabled: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 14,
        fontFamily: 'Segoe UI Symbol',
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      ),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
      backgroundColor: const Color(0xFFB0B0B0), // gray color
      foregroundColor: const Color(0xFFE0E0E0), // light gray text
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    DsButtonVariant.primaryTransaction: ElevatedButton.styleFrom(
      textStyle: DsText.styles[DsTextVariant.baseBold],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      backgroundColor: const Color.fromRGBO(0, 64, 128, 1),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    DsButtonVariant.elevatedTransaction: ElevatedButton.styleFrom(
      textStyle: DsText.styles[DsTextVariant.baseBold],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      backgroundColor: Colors.white,
      foregroundColor: const Color.fromRGBO(0, 64, 128, 1),
      side: const BorderSide(color: Color.fromRGBO(209, 213, 219, 1), width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    DsButtonVariant.primarySignUp: ElevatedButton.styleFrom(
      textStyle: DsText.styles[DsTextVariant.baseBold],
      padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 16),
      backgroundColor: const Color.fromRGBO(0, 64, 128, 1),
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    DsButtonVariant.elevatedSignUp: ElevatedButton.styleFrom(
      textStyle: DsText.styles[DsTextVariant.baseBold],
      padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 16),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      foregroundColor: const Color.fromARGB(0, 64, 128, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    DsButtonVariant.signUp: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFEAF2FB), // Cor do Figma (#EAF2FB)
      foregroundColor: const Color(0xFF004080), // Cor do texto (#004080)
      textStyle: DsText.styles[DsTextVariant.baseBold],
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0, // Sem sombra
    ),
  };

  // Mapeamento para BoxShadows específicas, se necessário

  @override
  Widget build(BuildContext context) {
    final style = _styles[variant]!;

    // Caso contrário, retorna o ElevatedButton diretamente
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Text(text),
      ),
    );
  }
}
