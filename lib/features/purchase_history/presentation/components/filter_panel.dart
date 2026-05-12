import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/features/purchase_history/core/purchase_history_store.dart';

class PurchaseHistoryFilter extends StatelessWidget {
  final PurchaseHistoryStore store;
  final List<String> paymentMethods;
  final List<String> statusOptions;

  const PurchaseHistoryFilter({
    Key? key,
    required this.store,
    required this.paymentMethods,
    required this.statusOptions,
  }) : super(key: key);

  Future<void> _pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: store.startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    store.setStartDate(picked);
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: store.endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    store.setEndDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 8)],
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Data início
              SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DsText(
                        text: 'Data início', variant: DsTextVariant.small),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickStartDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          hintText: 'Data inic.',
                          prefixIcon: const Icon(Icons.calendar_today_outlined,
                              color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        child: DsText(
                          text: store.startDate != null
                              ? store.startDate!.toString().substring(0, 10)
                              : '',
                          variant: DsTextVariant.small,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Data fim
              SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DsText(
                        text: 'Data fim', variant: DsTextVariant.small),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickEndDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          hintText: 'Data fim',
                          prefixIcon: const Icon(Icons.calendar_today_outlined,
                              color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        child: DsText(
                          text: store.endDate != null
                              ? store.endDate!.toString().substring(0, 10)
                              : '',
                          variant: DsTextVariant.small,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Tipo pagamento
              SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DsText(
                        text: 'Tipo de pagamento',
                        variant: DsTextVariant.small),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: store.paymentFilter,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: paymentMethods
                          .map((m) => DropdownMenuItem(
                                value: m,
                                child: DsText(
                                    text: m, variant: DsTextVariant.small),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) store.setPaymentFilter(v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Status pagamento
              SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DsText(
                        text: 'Status do pagamento',
                        variant: DsTextVariant.small),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: store.statusFilter,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: statusOptions
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: DsText(
                                    text: s, variant: DsTextVariant.small),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) store.setStatusFilter(v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Limpar filtros
              SizedBox(
                width: 140,
                child: OutlinedButton(
                  onPressed: () => store.clearFilters(),
                  child: const DsText(
                      text: 'Limpar filtros', variant: DsTextVariant.baseBold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
