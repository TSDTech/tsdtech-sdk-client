import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:voucherize/features/vouchers/core/stores/vouchers_store.dart';
import 'package:voucherize/models/vouchers/voucher.model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:voucherize/core/components/nav_header.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:voucherize/core/router/router.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

@RoutePage()
class VoucherQRCodeScreen extends StatelessWidget {
  final String voucherId;
  final String serviceId;
  final String code;
  const VoucherQRCodeScreen({super.key, required this.voucherId, required this.serviceId , required this.code});

  @override
  Widget build(BuildContext context) {
    final vouchersStore = GetIt.instance<VouchersStore>();
    vouchersStore.fetchMyVouchers();

    final fallback = vouchersStore.vouchers.isNotEmpty ? vouchersStore.vouchers.first : null;
    final vid = voucherId.isNotEmpty ? voucherId : (fallback?.id ?? '');

    final Voucher voucherObj = vouchersStore.vouchers.firstWhere(
      (v) => v.id == vid,
      orElse: () => fallback ?? Voucher(id: vid, serviceId: serviceId, status: '', validity: '', description: '', code: code),
    );

  final qrPayload = { "type": "VOUCHER", "code": voucherObj.code };

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
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                                onPressed: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  } else if (voucherObj.id.isNotEmpty) {
                                    context.router.replace(MyVouchersRoute());
                                  } else {
                                    context.router.replace(const MyVouchersRoute());
                                  }
                                },
                              ),
                              const SizedBox(width: 4),
                              const Icon(LucideIcons.ticket400, color: Colors.black87),
                              const SizedBox(width: 8),
                              const DsText(text: 'Verificação do Voucher', variant: DsTextVariant.subTitleVoucher),
                            ],
                          ),
                          const SizedBox(height: 24),

                          DsText(
                              text: voucherObj.service?.name ?? voucherObj.id,
                              variant: DsTextVariant.baseBold),
                          const SizedBox(height: 8),
                          DsText(
                            text: 'Código do Serviço: ${voucherObj.serviceId}',
                            variant: DsTextVariant.small,
                          ),
                          const SizedBox(height: 4),
                          DsText(
                            text: 'Voucher nº: ${voucherObj.id}',
                            variant: DsTextVariant.small,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: DsText(
                                  text: 'Código do Voucher: ${voucherObj.code}',
                                  variant: DsTextVariant.small,
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                tooltip: 'Copiar código',
                                icon: const Icon(Icons.copy, size: 18),
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                onPressed: () async {
                                  try {
                                    await Clipboard.setData(ClipboardData(text: voucherObj.code));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Código copiado para a área de transferência')),
                                    );
                                  } catch (_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Não foi possível copiar o código')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          DsText(
                            text: voucherObj.service?.description ?? voucherObj.description ?? '',
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

                          // Appointment Info (from voucher.createdAt)
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Builder(builder: (ctx) {
                                String createdText = 'Emitido: -';
                                final created = voucherObj.createdAt;
                                if (created != null && created.isNotEmpty) {
                                  try {
                                    final date = DateTime.parse(created);
                                    final day = date.day.toString().padLeft(2, '0');
                                    final month = date.month.toString().padLeft(2, '0');
                                    final year = date.year.toString();
                                    final hour = date.hour.toString();
                                    createdText = 'Emitido: $day/$month/$year às ${hour}h';
                                  } catch (_) {
                                    createdText = 'Emitido: -';
                                  }
                                }
                                return DsText(text: createdText, variant: DsTextVariant.small);
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
