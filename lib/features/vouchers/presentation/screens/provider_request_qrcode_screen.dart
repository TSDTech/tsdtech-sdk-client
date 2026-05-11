import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/provider_request_store.dart';
import 'package:tsdtech_client_sdk/models/vouchers/provider_request.model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tsdtech_client_sdk/core/components/nav_header.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/vouchers_store.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';
// import 'package:tsdtech_client_sdk/models/vouchers/voucher.model.dart';

@RoutePage()
class ProviderRequestQRCodeScreen extends StatelessWidget {
  final String providerRequestId;
  final String serviceId;
  final String administratorId;
  const ProviderRequestQRCodeScreen({super.key, required this.providerRequestId, required this.serviceId, required this.administratorId});

  @override
  Widget build(BuildContext context) {
  final vouchersStore = GetIt.instance<VouchersStore>();
  final providerStore = GetIt.instance<ProviderRequestStore>();
  // Ensure vouchers/provider requests are loaded
  vouchersStore.fetchMyVouchers();
  providerStore.fetchProviderRequests();
    // Use selected ids from the provider store or fallback to first pending request
    final fallback = providerStore.providerRequests.isNotEmpty ? providerStore.providerRequests.first : null;
    final providerRequestId = providerStore.selectedProviderRequestId ?? (fallback?.id ?? '');

  // Build QR payload containing only the providerRequestId
  //final qrPayload = {"type" : "PROVIDER-REQUEST", "code" : providerRequestCode};
  final qrPayload = { "type": "PROVIDER-REQUEST", "code": providerRequestId };

    // find the providerRequest object for display (may be null)
    final ProviderRequest providerRequestObj = providerStore.providerRequests.firstWhere(
      (r) => r.id == providerRequestId,
      orElse: () => fallback ?? ProviderRequest(id: '0'),
    );

    return Scaffold(
      appBar: const NavHeader(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const DsText(
                      text: 'Portal do Cidadão',
                      variant: DsTextVariant.titleVoucher),
                  const SizedBox(height: 4),
                  const DsText(
                    text:
                        'Tudo mais fácil: escolha o serviço, compre seu voucher e acompanhe seus cupons',
                    variant: DsTextVariant.textVoucher,
                  ),
                  const SizedBox(height: 24),

                  // Main Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        const BoxShadow(color: Colors.black12, blurRadius: 8)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with icon and a top-left replace/back button inside the body
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                                onPressed: () {
                                  // Prefer pop when possible (returns to previous screen).
                                  // If there's nothing to pop (screen opened directly), replace with the form route.
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  } else if (providerRequestId.isNotEmpty) {
                                    context.router.replace(ProviderRequestFormRoute(providerRequestId: providerRequestId, serviceId: providerRequestObj.serviceId ?? '', administratorId: providerRequestObj.administratorId ?? ''));
                                  } else {
                                    // As a last resort, replace to the MyVouchers screen
                                    context.router.replace(const MyVouchersRoute());
                                  }
                                },
                              ),
                              const SizedBox(width: 4),
                              const Icon(LucideIcons.ticket400, color: Colors.black87),
                              const SizedBox(width: 8),
                              const DsText(text: 'Verificação do Serviço', variant: DsTextVariant.subTitleVoucher),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Voucher Info
              DsText(
                text: providerRequestObj.service?.name ?? (providerRequestObj.serviceName.isNotEmpty ? providerRequestObj.serviceName : providerRequestId),
                variant: DsTextVariant.baseBold),
              const SizedBox(height: 8),
                          DsText(
                            text: providerRequestObj.service?.description ?? (providerRequestObj.observacoes.isNotEmpty ? providerRequestObj.observacoes : ''),
                            variant: DsTextVariant.small,
                          ),
                          const SizedBox(height: 24),

                          // QR Code Section
                          const DsText(
                              text: 'Apresente este QR Code para verificação',
                              variant: DsTextVariant.small),
                          const SizedBox(height: 16),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: QrImageView(
                                data: json.encode(qrPayload),
                                version: QrVersions.auto,
                                size: 200.0,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Appointment Info (from providerRequest.updatedAt)
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Builder(builder: (ctx) {
                                String appointmentText = 'Agendado: -';
                                final created = providerRequestObj.createdAt;
                                if (created != null && created.isNotEmpty) {
                                  try {
                                    final date = DateTime.parse(created);
                                    final day = date.day.toString().padLeft(2, '0');
                                    final month = date.month.toString().padLeft(2, '0');
                                    final year = date.year.toString();
                                    final hour = date.hour.toString();
                                    appointmentText = 'Agendado: $day/$month/$year às ${hour}h';
                                  } catch (_) {
                                    appointmentText = 'Agendado: -';
                                  }
                                }
                                return DsText(text: appointmentText, variant: DsTextVariant.small);
                              }),
                            ],
                          ),
                          const SizedBox(height: 16),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
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
