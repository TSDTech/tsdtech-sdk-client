import 'package:flutter/material.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:voucherize/features/vouchers/core/stores/provider_request_store.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:voucherize/models/vouchers/provider_request.model.dart';

/// A separate confirmation modal for provider requests.
///
/// This modal intentionally does NOT call the voucher submission flow.
/// Callers should pass an optional [onConfirm] callback that performs the
/// provider-request-specific submission and returns `true` on success.
void showConfirmProviderRequestModal(
  BuildContext context,
  String providerRequestId,
  String serviceId,
  String administratorId, {
  Map<String, dynamic>? payload,
  Future<bool> Function(Map<String, dynamic>? payload)? onConfirm,
}) {
  final providerRequestStore = GetIt.instance<ProviderRequestStore>();

  ProviderRequest? providerRequest;
  try {
    providerRequest = providerRequestStore.providerRequests.firstWhere((r) => r.id == providerRequestId);
  } catch (_) {
    providerRequest = null;
  }

  final now = DateTime.now();
  final formattedDate = DateFormat('dd/MM/yyyy \'às\' HH\'h\'').format(now);

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6FFFA),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 40),
                ),
                const SizedBox(height: 18),
                const DsText(text: 'Confirmar envio do pedido ao provedor?', variant: DsTextVariant.baseBold),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAEEF2)),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.send_outlined, size: 32, color: Colors.black54),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DsText(text: providerRequest?.service?.name ?? '-', variant: DsTextVariant.baseBold),
                            const SizedBox(height: 4),
                            DsText(text: 'Pedido nº: ${providerRequest?.id ?? providerRequestId}', variant: DsTextVariant.small),
                            const SizedBox(height: 4),
                            DsText(text: 'Data/horário: $formattedDate', variant: DsTextVariant.small),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                DsText(text: 'Serviço: ${providerRequest?.service?.name ?? serviceId}', variant: DsTextVariant.small),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFE0B2)),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFA726), size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            DsText(text: 'Observação:', variant: DsTextVariant.baseBold, color: Color(0xFFFFA726)),
                            SizedBox(height: 2),
                            DsText(text: 'Após o envio, o provedor será notificado. Acompanhe o status na lista de pedidos.', variant: DsTextVariant.small, color: Color(0xFF7A5A00)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const DsText(text: 'Voltar', variant: DsTextVariant.baseBold),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFFEAEEF2)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // If an onConfirm callback is provided, use it for submission.
                          if (onConfirm != null) {
                            bool success = false;
                            try {
                              success = await onConfirm(payload);
                            } catch (_) {
                              success = false;
                            }
                            if (!success) {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Erro ao enviar pedido ao provedor. Tente novamente.')),
                              );
                              return;
                            }
                          }

                          // Optionally refresh provider requests list to reflect backend changes
                          try {
                            await providerRequestStore.fetchProviderRequests();
                          } catch (_) {}

                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pedido enviado ao provedor com sucesso.')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const DsText(text: 'Confirmar envio', variant: DsTextVariant.baseBold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
