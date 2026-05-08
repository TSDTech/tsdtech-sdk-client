class PhoneNumberFormatter {
  /// Formatar número de telefone brasileiro no formato (XX) 9XXXX-XXXX ou (XX) XXXX-XXXX
  static String format(String phone) {
    // Remove caracteres não numéricos
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length == 11) {
      // Formato: (XX) 9XXXX-XXXX
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 3)}${cleanPhone.substring(3, 7)}-${cleanPhone.substring(7)}';
    } else if (cleanPhone.length == 10) {
      // Formato: (XX) XXXX-XXXX
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(2, 6)}-${cleanPhone.substring(6)}';
    }
    
    // Retorna o telefone original se não conseguir formatar
    return phone;
  }

  /// Remove caracteres não numéricos do telefone
  static String clean(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Prepara o telefone para WhatsApp (adiciona código do país se necessário)
  static String formatForWhatsApp(String phone) {
    final cleanPhone = clean(phone);
    return cleanPhone.startsWith('55') ? cleanPhone : '55$cleanPhone';
  }

  /// Valida se o telefone tem um formato válido (10 ou 11 dígitos)
  static bool isValid(String phone) {
    final cleanPhone = clean(phone);
    return cleanPhone.length == 10 || cleanPhone.length == 11;
  }
} 