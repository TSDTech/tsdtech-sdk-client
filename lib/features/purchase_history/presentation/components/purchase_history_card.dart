import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:voucherize/features/purchase_history/core/purchase_history_store.dart';

class PurchaseHistoryTable extends StatelessWidget {
  const PurchaseHistoryTable({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case 'Confirmado':
        return const Color(0xFFCCF7D8);
      case 'Pendente':
        return const Color(0xFFFFF7E6);
      case 'Falhado':
        return const Color(0xFFFFE0E0);
      case 'Cancelado':
        return const Color(0xFFFFE0E0);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'Confirmado':
        return const Color(0xFF199A4E);
      case 'Pendente':
        return const Color(0xFF7A5A00);
      case 'Falhado':
        return const Color(0xFFD32F2F);
      case 'Cancelado':
        return const Color(0xFFD32F2F);
      default:
        return Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = GetIt.instance<PurchaseHistoryStore>();

    return Observer(builder: (_) {
      if (store.isLoading) {
        return const Center(
          child: SizedBox(height: 64, width: 64, child: CircularProgressIndicator()),
        );
      }

      if (store.lastFetchResult != null && store.lastFetchResult!.isError) {
        final err = store.lastFetchResult!.error;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: DsText(text: 'Erro ao carregar histórico: $err', variant: DsTextVariant.baseBold),
        );
      }

      final purchases = store.purchases.toList();

      if (purchases.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: DsText(text: 'Nenhum resultado encontrado.', variant: DsTextVariant.baseBold),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 0,
          dataRowHeight: 70,
          columns: const [
            DataColumn(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 210,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DsText(text: 'ID Transação', variant: DsTextVariant.baseBold),
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 210,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DsText(text: 'Data/hora', variant: DsTextVariant.baseBold),
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 280,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DsText(text: 'Forma de pagamento', variant: DsTextVariant.baseBold),
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 210,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DsText(text: 'Valor pago', variant: DsTextVariant.baseBold),
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 210,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DsText(text: 'Status', variant: DsTextVariant.baseBold),
                  ),
                ),
              ),
            ),
          ],
          rows: purchases.map((p) {
            return DataRow(cells: [
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 110,
                    child: Align(alignment: Alignment.centerLeft, child: DsText(text: p['transactionId'] ?? '', variant: DsTextVariant.baseBold)),
                  ),
                ),
              ),
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 110,
                    child: Align(alignment: Alignment.centerLeft, child: DsText(text: p['date'] ?? '', variant: DsTextVariant.small)),
                  ),
                ),
              ),
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 180,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(p['paymentMethod'] == 'PIX' ? Icons.qr_code : p['paymentMethod'] == 'Crédito' ? Icons.credit_card : Icons.receipt_long, size: 18, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          DsText(text: p['paymentMethod'] ?? '', variant: DsTextVariant.small),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 110,
                    child: Align(alignment: Alignment.centerLeft, child: DsText(text: p['amount'] ?? '', variant: DsTextVariant.baseBold, color: const Color(0xFF199A4E))),
                  ),
                ),
              ),
              DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 110,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(p['status'] ?? ''),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerLeft,
                      child: DsText(text: p['status'] ?? '', variant: DsTextVariant.baseBold, color: getStatusTextColor(p['status'] ?? '')),
                    ),
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      );
    });
  }
}
