import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:voucherize/core/components/nav_header.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:voucherize/features/purchase_history/presentation/components/purchase_history_card.dart';
// import 'package:voucherize/features/purchase_history/presentation/components/filter_panel.dart';
import 'package:voucherize/features/purchase_history/core/purchase_history_store.dart';

@RoutePage()
class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.instance<PurchaseHistoryStore>();

    // Load purchases from API once when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (store.purchases.isEmpty) {
        store.loadOrdersFromApi(page: 1, pageSize: store.pageSize);
      }
    });

    return Scaffold(
      appBar: const NavHeader(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (sn) {
          try {
            final metrics = sn.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              if (!store.isLoading && store.hasMore) {
                store.loadOrdersFromApi(page: store.currentPage + 1, pageSize: store.pageSize);
              }
            }
          } catch (_) {}
          return false;
        },
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DsText(text: 'Portal do Cidadão', variant: DsTextVariant.titleVoucher),
                    const SizedBox(height: 8),
                    const DsText(text: 'Tudo mais fácil: escolha o serviço, compre seu voucher e acompanhe seus cupons.', variant: DsTextVariant.textVoucher),
                    const SizedBox(height: 24),
                    // PurchaseHistoryFilter(
                    //   store: store,
                    //   paymentMethods: paymentMethods,
                    //   statusOptions: statusOptions,
                    // ),
                    // const SizedBox(height: 24),
                    Observer(
                      builder: (_) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                                child: Row(
                                  children: const [
                                    Icon(Icons.person_outline, color: Colors.black54),
                                    SizedBox(width: 8),
                                    DsText(text: 'Meu perfil  >  Histórico de pagamentos', variant: DsTextVariant.baseBold),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: const PurchaseHistoryTable(),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
