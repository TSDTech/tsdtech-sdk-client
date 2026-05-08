import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:voucherize/core/components/nav_header.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:voucherize/core/local_storage/administrator/administrator_id.prefs.dart';
import 'package:voucherize/features/vouchers/core/stores/vouchers_store.dart';
import 'package:voucherize/features/vouchers/core/stores/provider_request_store.dart';
import 'package:voucherize/features/vouchers/presentation/components/voucher_filters.dart';
import 'package:voucherize/features/vouchers/presentation/components/voucher_tabs.dart';
import 'package:voucherize/features/vouchers/presentation/components/voucher_card.dart';
import 'package:voucherize/features/vouchers/presentation/components/provider_request_card.dart';
import 'package:voucherize/models/vouchers/voucher.model.dart';
import 'package:voucherize/core/router/router.dart';
import 'package:voucherize/models/vouchers/provider_request.model.dart';
// replaced shimmer with a simple circular loader per user preference

@RoutePage()
class MyVouchersScreen extends StatelessWidget {
  const MyVouchersScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
  final vouchersStore = GetIt.instance<VouchersStore>();
  final providerRequestStore = GetIt.instance<ProviderRequestStore>();
    // Always fetch fresh data when the page is accessed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vouchersStore.fetchMyVouchers(page: 1, pageSizeParam: 10);
      providerRequestStore.fetchProviderRequests(page: 1, pageSizeParam: 10);
    });
    return Scaffold(
      appBar: const NavHeader(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (sn) {
          try {
            final metrics = sn.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              // near bottom -> load more depending on selected tab
              if (vouchersStore.selectedTab == 0) {
                if (!vouchersStore.isLoading && vouchersStore.hasMore) {
                  vouchersStore.fetchMyVouchers(page: vouchersStore.currentPage + 1, pageSizeParam: 10);
                }
              } else {
                if (!providerRequestStore.isLoading && providerRequestStore.hasMore) {
                  providerRequestStore.fetchProviderRequests(page: providerRequestStore.currentPage + 1, pageSizeParam: 10);
                }
              }
            }
          } catch (_) {}
          return false;
        },
        child: SingleChildScrollView(
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
                        'Tudo mais fácil: escolha o serviço, compre seu voucher \ne acompanhe seus cupons',
                    variant: DsTextVariant.textVoucher,
                  ),
                  const SizedBox(height: 24),

                  // Card container
                  Container(
                    width: double.infinity,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(64, 31, 64, 31),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título com ícone
                              Row(
                                children: [
                                  const Icon(LucideIcons.ticket400,
                                      color: Colors.black87),
                                  const SizedBox(width: 8),
                                  const DsText(
                                      text: 'Meus Cupons',
                                      variant: DsTextVariant.subTitleVoucher),
                                ],
                              ),
                              const SizedBox(height: 27),

                              // Filtros
                              // VoucherFilters(vouchersStore: vouchersStore, providerRequestStore: providerRequestStore),
                              // const SizedBox(height: 32),

                              // Contador de cupons disponíveis
                              // Observer(builder: (_) {
                              //   return DsText(
                              //       text: '${vouchersStore.availableCount} cupons disponíveis',
                              //       variant: DsTextVariant.small);
                              // }),
                            ],
                          ),
                        ),
                        // Divider full width
                        const Divider(),
                        // Tabs full width
                        VoucherTabs(voucherStore: vouchersStore, providerStore: providerRequestStore),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(64, 0, 64, 32),
                          child: Observer(builder: (_) => _buildContent(context, vouchersStore, providerRequestStore)),
                        ),
                      ],
                    ),
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



  Widget _buildVoucherList(BuildContext context, VouchersStore vouchersStore, List<Voucher> vouchers) {
    final administratorId = AdministratorIdPrefs.get();
    final items = vouchers
        .map((voucher) => VoucherCard(
              voucher: voucher,
              onSchedule: () {
                context.router.push(MyVouchersFormRoute(serviceId: voucher.serviceId, administratorId: administratorId ?? '', formId: voucher.formId ?? ''));
              },
            ))
        .toList();

    // If loading more pages, show a bottom loader
    if (vouchersStore.isLoading && vouchers.isNotEmpty) {
      return Column(
        children: [
          ...items,
          const SizedBox(height: 12),
          const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5))),
        ],
      );
    }

    return Column(children: items);
  }

  Widget _buildContent(BuildContext context, VouchersStore vouchersStore, ProviderRequestStore providerRequestStore) {
    switch (vouchersStore.selectedTab) {
      case 0:
        if (vouchersStore.isLoading && vouchersStore.vouchers.isEmpty) {
          return const Center(child: SizedBox(width: 48, height: 48, child: CircularProgressIndicator()));
        }
  return _buildVoucherList(context, vouchersStore, vouchersStore.filteredVouchers);
      case 1:
        if (providerRequestStore.isLoading && providerRequestStore.providerRequests.isEmpty) {
          return const Center(child: SizedBox(width: 48, height: 48, child: CircularProgressIndicator()));
        }
  return _buildProviderRequestList(context, providerRequestStore, providerRequestStore.filteredScheduledRequests);
      case 2:
        if (providerRequestStore.isLoading && providerRequestStore.providerRequests.isEmpty) {
          return const Center(child: SizedBox(width: 48, height: 48, child: CircularProgressIndicator()));
        }
  return _buildProviderRequestList(context, providerRequestStore, providerRequestStore.filteredCompletedRequests);
      default:
        if (vouchersStore.isLoading && vouchersStore.vouchers.isEmpty) {
          return const Center(child: SizedBox(width: 48, height: 48, child: CircularProgressIndicator()));
        }
  return _buildVoucherList(context, vouchersStore, vouchersStore.filteredVouchers);
    }
  }
  Widget _buildProviderRequestList(BuildContext context, ProviderRequestStore providerRequestStore, List<ProviderRequest> requests) {
    final administratorId = AdministratorIdPrefs.get();
    final items = requests.map((request) {
      return ProviderRequestCard(
        request: request,
        onViewDetails: () {
          // If the provider request is finished/rejected/completed -> open finished screen
          final st = request.status.toUpperCase();
          if (st == 'FINISHED' || st == 'REJECTED' || st == 'COMPLETED') {
            context.router.push(ProviderRequestFinishedRoute(providerRequestId: request.id));
          } else {
            // Navigate to provider request form for pending/in-progress requests
            context.router.push(ProviderRequestFormRoute(serviceId: request.serviceId ?? '', administratorId: administratorId ?? '', providerRequestId: request.id));
          }
        },
      );
    }).toList();

    if (providerRequestStore.isLoading && requests.isNotEmpty) {
      return Column(
        children: [
          ...items,
          const SizedBox(height: 12),
          const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5))),
        ],
      );
    }

    return Column(children: items);
  }




}
