import 'package:flutter/material.dart';

/// Enum que centraliza o texto, cor e ícone para tipos de resultado
/// usados em vouchers / provider requests.
enum ResultType { approved, pending, rejected, unknown }

extension ResultTypeX on ResultType {
  /// Texto exibido no UI (em português).
  String get label {
    switch (this) {
      case ResultType.approved:
        return 'Aprovado';
      case ResultType.pending:
        return 'Pendente';
      case ResultType.rejected:
        return 'Rejeitado';
      case ResultType.unknown:
        return 'Desconhecido';
    }
  }

  /// Cor associada ao tipo (valores hex para consistência com o design).
  Color get color {
    switch (this) {
      case ResultType.approved:
        return const Color(0xFF10B981); // verde
      case ResultType.pending:
        return const Color(0xFFFFA726); // laranja/amarelo
      case ResultType.rejected:
        return Colors.red; // vermelho
      case ResultType.unknown:
        return const Color(0xFF2563EB); // azul (fallback)
    }
  }

  /// Ícone apropriado para exibição em chips/labels.
  IconData get icon {
    switch (this) {
      case ResultType.approved:
        return Icons.check_circle_outline;
      case ResultType.pending:
        return Icons.warning_amber_rounded;
      case ResultType.rejected:
        return Icons.error_outline;
      case ResultType.unknown:
        return Icons.help_outline;
    }
  }

  /// Constrói um ResultType a partir de uma string de status vinda do backend.
  /// Faz comparações insensíveis a maiúsculas e trata vários sinônimos comuns.
  static ResultType fromStatus(String? status) {
    if (status == null || status.isEmpty) return ResultType.unknown;
    final s = status.toUpperCase();
    if (['FINISHED', 'CONCLUDED', 'COMPLETED', 'APPROVED', 'SUCCESS']
        .contains(s)) {
      return ResultType.approved;
    }
    if (['REJECTED', 'DENIED', 'FAILED'].contains(s)) {
      return ResultType.rejected;
    }
    if (['PENDING', 'IN_PROGRESS', 'WAITING', 'PROCESSING', 'SCHEDULED']
        .contains(s)) {
      return ResultType.pending;
    }
    return ResultType.unknown;
  }
}
