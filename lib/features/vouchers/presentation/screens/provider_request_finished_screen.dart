import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:tsdtech_client_sdk/core/components/nav_header.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';
import 'package:tsdtech_client_sdk/models/vouchers/result_type.dart';
import 'package:tsdtech_client_sdk/features/vouchers/presentation/components/comprovante_modal.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/provider_request_store.dart';

@RoutePage()
class ProviderRequestFinishedScreen extends StatelessWidget {
  final String providerRequestId;
  const ProviderRequestFinishedScreen(
      {super.key, required this.providerRequestId});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.instance<ProviderRequestStore>();
    final request = store.providerRequests
        .where((r) => r.id == providerRequestId)
        .firstOrNull;
    if (request == null) {
      return const Scaffold(
        appBar: NavHeader(),
        body: Center(
            child: DsText(
                text: 'Provider request não encontrado.',
                variant: DsTextVariant.baseBold)),
      );
    }
    return Scaffold(
      appBar: const NavHeader(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  const BoxShadow(color: Colors.black12, blurRadius: 8)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // top row with back arrow and breadcrumb-like title (matches other screens)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            context.router.replace(const MyVouchersRoute());
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      DsText(
                          text: request.serviceName,
                          variant: DsTextVariant.titleVoucher),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Coluna esquerda
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // title moved to top row
                            const SizedBox(height: 8),
                            DsText(
                                text:
                                    'Código do Serviço: ${request.serviceId ?? request.service?.id ?? ''}',
                                variant: DsTextVariant.small),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const DsText(
                                    text: 'Voucher ID: ',
                                    variant: DsTextVariant.small),
                                DsText(
                                    text: request.voucherId ??
                                        request.voucher?.id ??
                                        '',
                                    variant: DsTextVariant.baseBold),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DsText(
                                text:
                                    'Service ID: ${request.serviceId ?? request.service?.id ?? ''}',
                                variant: DsTextVariant.small),
                            const SizedBox(height: 12),
                            const DsText(
                                text:
                                    'Descrição do Serviço: Vistoria obrigatória em empresa credenciada quando há transferência, baixa ou alteração relevante de dados do veículo.',
                                variant: DsTextVariant.small),
                            const SizedBox(height: 24),
                            const DsText(
                                text: 'Histórico do Voucher',
                                variant: DsTextVariant.baseBold),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 18),
                                const SizedBox(width: 10),
                                DsText(
                                    text:
                                        'Criado: ${DateFormat('dd/MM/yyyy').format(request.inspectionDate ?? DateTime.now())} às ${DateFormat('HH').format(request.inspectionDate ?? DateTime.now())}hrs',
                                    variant: DsTextVariant.small),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    size: 18),
                                const SizedBox(width: 10),
                                DsText(
                                    text:
                                        'Agendado: ${DateFormat('dd/MM/yyyy').format(request.appointmentDate ?? DateTime.now())} às ${DateFormat('HH').format(request.appointmentDate ?? DateTime.now())}hrs',
                                    variant: DsTextVariant.small),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    color: Color(0xFF10B981), size: 18),
                                const SizedBox(width: 10),
                                DsText(
                                    text:
                                        'Concluído em ${DateFormat('dd/MM/yyyy').format(request.completedDate ?? DateTime.now())} às ${DateFormat('HH').format(request.completedDate ?? DateTime.now())}h',
                                    variant: DsTextVariant.small),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: 220,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  // show comprovante modal
                                  await showComprovanteModal(context, request);
                                },
                                icon: const Icon(Icons.download, size: 18),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                label: const DsText(
                                    text: 'Baixar comprovante',
                                    variant: DsTextVariant.baseBold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // vertical divider
                      const SizedBox(width: 24),
                      const VerticalDivider(
                          width: 1, thickness: 1, color: Color(0xFFEAEEF2)),
                      const SizedBox(width: 24),
                      // Coluna direita
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    color: Color(0xFF2563EB), size: 22),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const DsText(
                                      text: 'Concluídos',
                                      variant: DsTextVariant.baseBold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            // Result and Laudo in two columns on the same row
                            Builder(builder: (_) {
                              final type =
                                  ResultTypeX.fromStatus(request.status);

                              return Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const DsText(
                                            text: 'Resultado',
                                            variant: DsTextVariant.baseBold),
                                        const SizedBox(height: 6),
                                        Chip(
                                          avatar: Icon(type.icon,
                                              size: 18, color: Colors.white),
                                          label: Text(type.label,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600)),
                                          backgroundColor: type.color,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 6),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const DsText(
                                            text: 'Laudo nº',
                                            variant: DsTextVariant.baseBold),
                                        const SizedBox(height: 6),
                                        DsText(
                                            text: request.id,
                                            variant: DsTextVariant.baseBold),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(height: 18),
                            const DsText(
                                text: 'Inspetor / Credenciada',
                                variant: DsTextVariant.baseBold),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 18),
                                const SizedBox(width: 6),
                                DsText(
                                  text: (request.provider != null &&
                                          request.provider!['name'] != null)
                                      ? request.provider!['name'] as String
                                      : request.inspector,
                                  variant: DsTextVariant.small,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            DsText(
                                text:
                                    'Serviço concluído em ${DateFormat('dd/MM/yyyy').format(request.completedDate ?? DateTime.now())} às ${DateFormat('HH').format(request.completedDate ?? DateTime.now())}hrs.',
                                variant: DsTextVariant.small),
                            const SizedBox(height: 18),
                            DsText(
                                text: 'Observação: ${request.observacoes}',
                                variant: DsTextVariant.small),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
