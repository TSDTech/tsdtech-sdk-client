import 'package:flutter/services.dart';

class FormValidators {
  // ===== VALIDAÇÕES DE CARTÃO DE CRÉDITO =====

  /// Valida número do cartão de crédito
  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Número do cartão é obrigatório';
    }
    final cleaned = value.replaceAll(' ', '');
    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'Número do cartão inválido';
    }
    // Validação básica do algoritmo de Luhn
    if (!_isValidLuhn(cleaned)) {
      return 'Número do cartão inválido';
    }
    return null;
  }

  /// Valida data de expiração do cartão (MM/AA)
  static String? validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Validade é obrigatória';
    }
    final parts = value.split('/');
    if (parts.length != 2 || parts[0].length != 2 || parts[1].length != 2) {
      return 'Use o formato MM/AA';
    }
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return 'Mês inválido';
    }

    // Verifica se o cartão não está vencido
    final now = DateTime.now();
    final currentYear = now.year % 100; // últimos 2 dígitos do ano atual
    final currentMonth = now.month;

    if (year != null) {
      if (year < currentYear || (year == currentYear && month < currentMonth)) {
        return 'Cartão vencido';
      }
    }

    return null;
  }

  /// Valida CVV do cartão
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV é obrigatório';
    }
    if (value.length < 3 || value.length > 4) {
      return 'CVV deve ter 3 ou 4 dígitos';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'CVV deve conter apenas números';
    }
    return null;
  }

  /// Valida nome do titular do cartão
  static String? validateHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome do titular é obrigatório';
    }
    if (value.length < 2) {
      return 'Nome muito curto';
    }
    if (value.length > 50) {
      return 'Nome muito longo';
    }
    // Verifica se contém pelo menos 2 palavras
    if (value.trim().split(' ').length < 2) {
      return 'Digite o nome completo';
    }
    return null;
  }

  // ===== VALIDAÇÕES DE CPF =====

  /// Valida CPF brasileiro
  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cleaned)) {
      return 'CPF inválido';
    }

    // Validação do algoritmo do CPF
    if (!_isValidCPF(cleaned)) {
      return 'CPF inválido';
    }

    return null;
  }

  // ===== VALIDAÇÕES GERAIS =====

  /// Valida email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  /// Valida campo obrigatório genérico
  static String? validateRequired(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  /// Valida comprimento mínimo
  static String? validateMinLength(String? value, int minLength,
      {String fieldName = 'Campo'}) {
    if (value == null || value.length < minLength) {
      return '$fieldName deve ter pelo menos $minLength caracteres';
    }
    return null;
  }

  /// Valida comprimento máximo
  static String? validateMaxLength(String? value, int maxLength,
      {String fieldName = 'Campo'}) {
    if (value != null && value.length > maxLength) {
      return '$fieldName deve ter no máximo $maxLength caracteres';
    }
    return null;
  }

  // ===== MÉTODOS PRIVADOS =====

  /// Algoritmo de Luhn para validação de cartão de crédito
  static bool _isValidLuhn(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// Algoritmo de validação do CPF
  static bool _isValidCPF(String cpf) {
    // Calcula o primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) firstDigit = 0;

    // Verifica o primeiro dígito
    if (int.parse(cpf[9]) != firstDigit) return false;

    // Calcula o segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) secondDigit = 0;

    // Verifica o segundo dígito
    return int.parse(cpf[10]) == secondDigit;
  }
}

// ===== FORMATADORES =====

/// Formatador para número de cartão de crédito (grupos de 4 dígitos)
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');

    if (text.length <= 4) {
      return newValue.copyWith(text: text);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

/// Formatador para data de expiração (MM/AA)
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (text.length <= 2) {
      return newValue.copyWith(text: text);
    }

    final formattedText =
        '${text.substring(0, 2)}/${text.substring(2, text.length > 4 ? 4 : text.length)}';
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

/// Formatador para CPF (XXX.XXX.XXX-XX)
class CPFFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (text.length <= 3) {
      return newValue.copyWith(text: text);
    } else if (text.length <= 6) {
      return newValue.copyWith(
          text: '${text.substring(0, 3)}.${text.substring(3)}');
    } else if (text.length <= 9) {
      return newValue.copyWith(
        text:
            '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6)}',
      );
    } else {
      final formattedText =
          '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6, 9)}-${text.substring(9, text.length > 11 ? 11 : text.length)}';
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }
}
