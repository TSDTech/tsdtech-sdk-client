import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/provider_request_store.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/vouchers_store.dart';

class VoucherTabs extends StatelessWidget {
  final VouchersStore voucherStore;
  final ProviderRequestStore providerStore;

  const VoucherTabs({
    super.key,
    required this.voucherStore,
    required this.providerStore,
  });

  @override
  Widget build(BuildContext context) {
    List<String> labels = ['Disponíveis', 'Em Andamento', 'Concluídas'];
    List<IconData> icons = [
      LucideIcons.ticket,
      Icons.event_available_outlined,
      Icons.check_circle_outline
    ];

    return Observer(builder: (_) {
      final counts = [voucherStore.availableCount, providerStore.scheduledCount, providerStore.completedCount];
      return Row(
        children: List.generate(labels.length, (i) {
          bool active = voucherStore.selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => voucherStore.setSelectedTab(i),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  border: Border(
                    bottom: BorderSide(
                      color: active
                          ? (i == 0
                              ? const Color(0xFF10B981)
                              : i == 1
                                  ? const Color.fromRGBO(37, 99, 235, 1)
                                  : const Color.fromRGBO(55, 65, 81, 1))
                          : const Color.fromRGBO(107, 114, 128, 1),
                      width: 2,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icons[i],
                        size: 18,
                        color: active ? (i == 0 ? const Color(0xFF10B981) : i == 1 ? const Color.fromRGBO(37, 99, 235, 1) : const Color.fromRGBO(55, 65, 81, 1)) : Colors.grey),
                    const SizedBox(width: 10),
                    DsText(
                      text: labels[i],
                      variant: DsTextVariant.normal,
                      color: active ? (i == 0 ? const Color(0xFF10B981) : i == 1 ? const Color.fromRGBO(37, 99, 235, 1) : const Color.fromRGBO(55, 65, 81, 1)) : Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    // Container(
                    //   height: 20,
                    //   alignment: Alignment.center,
                    //   padding: const EdgeInsets.symmetric(horizontal: 8),
                    //   decoration: BoxDecoration(
                    //     color: active ? (i == 0 ? const Color(0xFF10B981) : i == 1 ? const Color.fromRGBO(37, 99, 235, 1) : const Color.fromRGBO(55, 65, 81, 1)) : Colors.grey,
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: DsText(
                    //     text: counts[i].toString(),
                    //     variant: DsTextVariant.smallBoldIcon,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
