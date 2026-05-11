import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/models/vouchers/provider_request.model.dart';

class ProviderRequestCard extends StatelessWidget {
  final ProviderRequest request;
  final VoidCallback? onViewDetails;

  const ProviderRequestCard({
    super.key,
    required this.request,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final st = request.status.toUpperCase();
    String statusText;
    Color statusColor;
    Color statusBgColor;
    switch (st) {
      case 'PENDING':
        statusText = 'Em andamento';
        statusColor = const Color(0xFFB45309); // amber/darker
        statusBgColor = const Color(0xFFFFF7ED);
        break;
      case 'FINISHED':
      case 'REJECTED':
      case 'COMPLETED':
        statusText = 'Concluído';
        statusColor = const Color.fromRGBO(55, 65, 81, 1);
        statusBgColor = const Color(0xFFF3F4F6);
        break;
      default:
        statusText = request.status;
        statusColor = Colors.grey;
        statusBgColor = Colors.grey[200]!;
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEAEEF2)),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DsText(
              text: request.service?.name ?? request.serviceName,
              variant: DsTextVariant.baseBold),
          const SizedBox(height: 6),
          DsText(
              text: 'Código do Serviço: ${request.serviceId ?? request.voucherServiceId}', variant: DsTextVariant.small),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DsText(
                  text: 'ID da Solicitação: ${request.id}', variant: DsTextVariant.small),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8)),
                child: DsText(
                    text: statusText,
                    variant: DsTextVariant.smallBold,
                    color: statusColor),
              )
            ],
          ),
      const SizedBox(height: 12),
          DsText(
            text: 'Data: ${_formatDate(request)}',
            variant: DsTextVariant.small,
          ),
          const SizedBox(height: 12),
          DsText(
            text: request.service?.description ?? request.observacoes,
            variant: DsTextVariant.small,
          ),
          if (request.provider != null && request.provider!['name'] != null) ...[
            const SizedBox(height: 12),
            DsText(
              text: 'Vistoriador: ${request.provider!['name']}',
              variant: DsTextVariant.small,
            ),
          ],
          if (request.plate.isNotEmpty || request.renavam.isNotEmpty || request.model.isNotEmpty || request.year.isNotEmpty) ...[
            const SizedBox(height: 12),
            DsText(
              text: 'Placa: ${request.plate} | RENAVAM: ${request.renavam} | Modelo: ${request.model} | Ano: ${request.year}',
              variant: DsTextVariant.small,
            ),
          ],
          if (request.observacoes.isNotEmpty) ...[
            const SizedBox(height: 12),
            DsText(
              text: 'Observações: ${request.observacoes}',
              variant: DsTextVariant.small,
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              // Show "Ver detalhes" for finished/rejected/completed requests
              if (st == 'FINISHED' || st == 'REJECTED' || st == 'COMPLETED')
                TextButton(
                  onPressed: onViewDetails,
                  child: const DsText(text: 'Ver detalhes', variant: DsTextVariant.small),
                ),
            ],
          )
        ],
      ),
    );
  }

  
  String _formatDate(ProviderRequest r) {
    // Always show createdAt as the card date (created timestamp of provider request)
    final dateStr = r.createdAt;
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();
      return '$day/$month/$year';
    } catch (_) {
      return '-';
    }
    
  }
}
