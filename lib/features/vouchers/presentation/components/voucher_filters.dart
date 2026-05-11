import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/vouchers_store.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/provider_request_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class VoucherFilters extends StatelessWidget {
  final VouchersStore vouchersStore;
  final ProviderRequestStore providerRequestStore;

  const VoucherFilters({
    super.key,
    required this.vouchersStore,
    required this.providerRequestStore,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      // Collect all unique tags from vouchers and provider requests
      final allTags = <String>{};
      for (final v in vouchersStore.vouchers) {
        if (v.service?.tags != null) {
          allTags.addAll(v.service!.tags!);
        }
      }
      for (final pr in providerRequestStore.providerRequests) {
        if (pr.service?.tags != null) {
          allTags.addAll(pr.service!.tags!);
        }
      }
      final sortedTags = allTags.toList()..sort();

      return Row(
        children: [
          // Busca (visual only; logic removed)
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (_) {},
              decoration: InputDecoration(
                hintText: 'Digite o nome do serviço',
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Data Inicial
          Expanded(
            child: AbsorbPointer(
              child: TextField(
                controller: TextEditingController(text: vouchersStore.startDateFilter.isNotEmpty ? DateFormat('dd/MM/yyyy').format(DateTime.parse(vouchersStore.startDateFilter)) : ''),
                onChanged: (_) {},
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Data inicial',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Data Final
          Expanded(
            child: AbsorbPointer(
              child: TextField(
                controller: TextEditingController(text: vouchersStore.endDateFilter.isNotEmpty ? DateFormat('dd/MM/yyyy').format(DateTime.parse(vouchersStore.endDateFilter)) : ''),
                onChanged: (_) {},
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Data final',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Clear dates button
          SizedBox(
            width: 40,
            child: IconButton(
              tooltip: 'Limpar datas',
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: null,
            ),
          ),
          const SizedBox(width: 12),
          // Dropdown Tags
          Expanded(
            child: DropdownButtonFormField<String>(
              value: vouchersStore.tagFilter,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: const DsText(text: 'Tags', variant: DsTextVariant.small),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: DsText(text: 'Todas', variant: DsTextVariant.small),
                ),
                ...sortedTags.map((tag) => DropdownMenuItem(
                  value: tag,
                  child: DsText(text: tag, variant: DsTextVariant.small),
                )),
              ],
              onChanged: null,
            ),
          ),
        ],
      );
    });
  }
}
