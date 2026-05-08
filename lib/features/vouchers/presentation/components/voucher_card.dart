import 'package:flutter/material.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:voucherize/models/vouchers/voucher.model.dart';
import 'package:voucherize/features/vouchers/presentation/screens/voucher_qrcode_screen.dart';

class VoucherCard extends StatelessWidget {
  final Voucher voucher;
  final VoidCallback? onSchedule;
  final VoidCallback? onViewDetails;

  const VoucherCard({
    super.key,
    required this.voucher,
    this.onSchedule,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;
    Color statusBgColor;
    final st = voucher.status.toUpperCase();
    switch (st) {
      case 'VALID':
      case 'AVAILABLE':
        statusText = 'Disponível';
        statusColor = const Color(0xFF10B981);
        statusBgColor = const Color(0xFFE6FFFA);
        break;
      case 'SCHEDULED':
        statusText = 'Em andamento';
        statusColor = const Color.fromRGBO(37, 99, 235, 1);
        statusBgColor = const Color(0xFFEBF4FF);
        break;
      case 'COMPLETED':
        statusText = 'Concluído';
        statusColor = const Color.fromRGBO(55, 65, 81, 1);
        statusBgColor = const Color(0xFFF3F4F6);
        break;
      default:
        statusText = 'Desconhecido';
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
              text: voucher.service?.name ?? '',
              variant: DsTextVariant.baseBold),
          const SizedBox(height: 6),
          DsText(
              text: 'Código do Serviço: ${voucher.serviceId}',
              variant: DsTextVariant.small),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DsText(
                  text: 'Voucher nº: ${voucher.id}',
                  variant: DsTextVariant.small),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          Row(children: [
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            DsText(
                text: 'Validade: ${_formatValidity(voucher)}',
                variant: DsTextVariant.small)
          ]),
          const SizedBox(height: 12),
          DsText(
            text: voucher.service?.description ?? voucher.description ?? '',
            variant: DsTextVariant.small,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // ElevatedButton(
              //     onPressed: onSchedule,
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: const Color(0xFF2563EB)),
              //     child: const DsText(
              //         text: 'Utilizar o Voucher',
              //         variant: DsTextVariant.baseBold,
              //         color: Colors.white)),
              const SizedBox(width: 12),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VoucherQRCodeScreen(
                            voucherId: voucher.id,
                            serviceId: voucher.serviceId,
                            code: voucher.code
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB)),
                  child: const DsText(
                      text: 'Ver QRCode',
                      variant: DsTextVariant.baseBold,
                      color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }

  String _formatValidity(Voucher v) {
    final ts = v.service?.validTimestamp;
    if (ts == null) return v.validity ?? '-';

    String? baseDateStr;
    try {
      baseDateStr = v.order != null && v.order!['createdAt'] != null
          ? v.order!['createdAt'] as String
          : v.createdAt ?? v.service?.createdAt?.toIso8601String();
    } catch (_) {
      baseDateStr = null;
    }

    DateTime? expiry;
    if (baseDateStr != null) {
      try {
        final base = DateTime.parse(baseDateStr);
        expiry = base.add(Duration(seconds: ts));
      } catch (_) {
        expiry = null;
      }
    }

    if (expiry == null) {
      if (ts > 1000000000000) {
        expiry = DateTime.fromMillisecondsSinceEpoch(ts);
      } else if (ts > 1000000000) {
        expiry = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      } else {
        return v.validity ?? '-';
      }
    }

    final day = expiry.day.toString().padLeft(2, '0');
    final month = expiry.month.toString().padLeft(2, '0');
    final year = expiry.year.toString();
    return '$day/$month/$year';
  }
}
