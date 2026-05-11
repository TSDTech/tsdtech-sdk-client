import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/vouchers_store.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/provider_request_store.dart';
import 'package:tsdtech_client_sdk/models/vouchers/voucher.model.dart';
import 'package:tsdtech_client_sdk/models/vouchers/provider_request.model.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-services/services/services_service.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';

void showConfirmVoucherModal(BuildContext context, VouchersStore store, String voucherServiceId, String administratorId, String providerSelectedId, String voucherId, {Map<String, dynamic>? payload}) {
  final Voucher voucher = store.vouchers.firstWhere(
    (v) => v.serviceId == voucherServiceId,
    orElse: () => store.vouchers.isNotEmpty ? store.vouchers.first : Voucher(id: '', serviceId: '', status: '', validity: '', description: '', code: ''),
  );
  final now = DateTime.now();
  final formattedDate = DateFormat('dd/MM/yyyy \'às\' HH\'h\'').format(now);
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1000),
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
                const DsText(text: 'Confirmar emissão da 2ª via?', variant: DsTextVariant.baseBold),
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
                      const Icon(Icons.confirmation_number_outlined, size: 32, color: Colors.black54),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DsText(text: voucher.service?.name ?? '-', variant: DsTextVariant.baseBold),
                            const SizedBox(height: 4),
                            DsText(text: 'Voucher nº: ${voucher.id}', variant: DsTextVariant.small),
                            const SizedBox(height: 4),
                            DsText(text: 'Data/horário: $formattedDate', variant: DsTextVariant.small),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                DsText(text: 'Validade: ${voucher.service?.validTimestamp ?? '-'}', variant: DsTextVariant.small),
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
                            DsText(text: 'Atenção: após a emissão não será possível cancelar ou solicitar reembolso.', variant: DsTextVariant.small, color: Color(0xFF7A5A00)),
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
                          // If payload is provided, submit it first
                            if (payload != null) {
                            final submitResult = await ServicesService.instance.submitServiceForm(
                                payload,
                                voucherId: voucher.id,
                                providerId: providerSelectedId,
                                serviceId: voucherServiceId,
                                administratorId: administratorId,
                            );
                            if (submitResult.isError || submitResult.value != true) {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Erro ao enviar formulário. Tente novamente.')),
                              );
                              return;
                            }
                          }
                        // Update local voucher status (optimistic)
                        final index = store.vouchers.indexOf(voucher);
                        if (index != -1) {
                          store.vouchers[index] = Voucher(
                            id: voucher.id,
                            serviceId: voucher.serviceId,
                            code: voucher.code,
                            status: 'scheduled',
                            validity: voucher.validity,
                            description: voucher.description,
                          );
                        }
                        // Add to provider requests (local) then refresh from backend
                        final providerRequestStore = GetIt.instance<ProviderRequestStore>();
                        providerRequestStore.providerRequests.add(ProviderRequest(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          voucherId: voucher.id,
                          voucherServiceId: voucher.serviceId,
                          serviceName: voucher.service?.name ?? '',
                          status: 'scheduled',
                          result: 'Pendente',
                          inspector: '',
                          inspectionDate: now,
                          appointmentDate: now,
                          completedDate: null,
                          plate: store.formValues['plate'] ?? '',
                          renavam: store.formValues['renavam'] ?? '',
                          model: store.formValues['model'] ?? '',
                          year: store.formValues['year'] ?? '',
                          observacoes: store.formValues['observacoes'] ?? '',
                        ));

                        // Refresh remote data to reflect possible changes in backend
                        try {
                          await store.fetchMyVouchers();
                        } catch (_) {}
                        try {
                          await providerRequestStore.fetchProviderRequests();
                        } catch (_) {}

                        // Close dialog and navigate back to MyVouchers screen
                        Navigator.of(ctx).pop();
                        // replace current route with vouchers list to ensure UI reflects updates
                        context.router.replace(const MyVouchersRoute());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Emissão confirmada! Voucher agendado.')),
                        );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const DsText(text: 'Confirmar emissão', variant: DsTextVariant.baseBold, color: Colors.white),
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
