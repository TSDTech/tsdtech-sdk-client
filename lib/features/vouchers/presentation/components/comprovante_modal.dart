import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/models/vouchers/provider_request.model.dart';
import 'package:tsdtech_client_sdk/models/vouchers/result_type.dart';

Future<void> showComprovanteModal(BuildContext context, ProviderRequest request) async {
  final type = ResultTypeX.fromStatus(request.status.isNotEmpty ? request.status : request.result);

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.insert_drive_file_outlined, size: 40, color: Colors.grey),
              const SizedBox(height: 12),
              DsText(text: 'Comprovante de Vistoria', variant: DsTextVariant.titleVoucher),
              const SizedBox(height: 8),
              DsText(text: 'Número do comprovante: #${request.id}', variant: DsTextVariant.small),
              const SizedBox(height: 6),
              DsText(text: 'Data de emissão: ${DateFormat('dd/MM/yyyy').format(request.completedDate ?? DateTime.now())} às ${DateFormat('HH').format(request.completedDate ?? DateTime.now())}hrs', variant: DsTextVariant.small),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DsText(text: 'Resultado final: ', variant: DsTextVariant.small),
                  const SizedBox(width: 6),
                  Chip(
                    avatar: Icon(type.icon, size: 16, color: Colors.white),
                    label: Text(type.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    backgroundColor: type.color,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DsText(text: 'Inspector/credenciada: ${request.provider != null && request.provider!['name'] != null ? request.provider!['name'] : '—'}', variant: DsTextVariant.small),
              const SizedBox(height: 6),
              DsText(text: 'Observação: ${request.observacoes}', variant: DsTextVariant.small),
              const SizedBox(height: 16),

              // PDF preview placeholder
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Icon(Icons.picture_as_pdf, size: 48, color: Colors.grey)),
              ),
              const SizedBox(height: 12),
              // filename link
              TextButton(
                onPressed: () {
                  // placeholder: in future, open PDF in new screen or download
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comprovante baixado com sucesso')));
                },
                child: Text('Comprovante_${request.id}.pdf', style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600)),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text('Fechar'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comprovante baixado com sucesso')));
                    },
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                    child: const Text('Baixar PDF'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
