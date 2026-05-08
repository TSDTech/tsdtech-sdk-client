import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:voucherize/core/components/nav_header.dart';
import 'package:voucherize/features/services_catalog/core/stores/home_store.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:voucherize/features/services_catalog/presentation/components/category_chip.dart';
import 'package:voucherize/features/cart/presentation/components/cart_drawer.dart';
import 'package:voucherize/features/services_catalog/presentation/components/services_grid.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.instance<HomeStore>();
    // load services once when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (store.services.isEmpty && !store.isLoading) {
        store.loadInitial();
      }
    });
    return Scaffold(
      appBar: const NavHeader(),
      endDrawer: const CartDrawer(),
      body: Observer(builder: (_) {
        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 988),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const DsText(text: 'Portal do Cidadão', variant: DsTextVariant.titleVoucher),
                  const SizedBox(height: 8),
                  const DsText(text: 'Tudo mais fácil: escolha o serviço, compre seu voucher \ne acompanhe seus cupons.', variant: DsTextVariant.textVoucher),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DsText(text: 'Catálogo de Serviços', variant: DsTextVariant.baseBold),
                          const SizedBox(height: 18),
                          const SizedBox(height: 8),
                          // Barra de busca
                          TextField(
                            onChanged: store.setSearchQuery,
                            decoration: InputDecoration(
                              hintText: 'Buscar por nome, código ou palavra-chave...',
                              filled: true,
                              fillColor: const Color(0xFFF3F4F6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Chips de categorias
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CategoryChip(
                                  label: 'Todos',
                                  selected: store.selectedCategory == null,
                                  onTap: () => store.selectCategory(null),
                                ),
                                const SizedBox(width: 8),
                                ...store.serviceTypes.map((t) => Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: CategoryChip(
                                        label: t.name ?? '—',
                                        selected: store.selectedCategory == t.id,
                                        onTap: () => store.selectCategory(t.id),
                                      ),
                                    )),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right, color: Color(0xFF2563EB)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
              // Grid/lista de serviços
              store.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ServicesGrid(services: store.filteredServices),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
