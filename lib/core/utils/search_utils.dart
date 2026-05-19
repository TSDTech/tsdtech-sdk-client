class SearchUtils {
  /// Função genérica para buscar em uma lista de objetos
  static List<T> searchInList<T>({
    required List<T> items,
    required String searchTerm,
    required List<String> Function(T item) getSearchableFields,
  }) {
    if (searchTerm.isEmpty) {
      return items;
    }

    final lowerSearchTerm = searchTerm.toLowerCase();

    return items.where((item) {
      final searchableFields = getSearchableFields(item);

      return searchableFields.any(
        (field) => field.toLowerCase().contains(lowerSearchTerm),
      );
    }).toList();
  }

  /// Função específica para normalizar texto removendo acentos e caracteres especiais
  static String normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàâãä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòôõö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .trim();
  }

  /// Função de busca avançada com normalização de texto
  static List<T> advancedSearch<T>({
    required List<T> items,
    required String searchTerm,
    required List<String> Function(T item) getSearchableFields,
  }) {
    if (searchTerm.isEmpty) {
      return items;
    }

    final normalizedSearchTerm = normalizeText(searchTerm);

    return items.where((item) {
      final searchableFields = getSearchableFields(item);

      return searchableFields.any(
        (field) => normalizeText(field).contains(normalizedSearchTerm),
      );
    }).toList();
  }

  /// Função para destacar texto encontrado (útil para UI)
  static String highlightSearchTerm(String text, String searchTerm) {
    if (searchTerm.isEmpty) return text;

    final regex = RegExp(searchTerm, caseSensitive: false);
    return text.replaceAllMapped(regex, (match) => '**${match.group(0)}**');
  }
}
