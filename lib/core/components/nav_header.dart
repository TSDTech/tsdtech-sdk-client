import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:voucherize/core/router/router.dart';
import 'package:voucherize/models/navigation/nav_item.model.dart';
import 'package:voucherize/core/components/ds_text.dart';
// ds_button removed from this file: replaced sign-up button with custom InkWell
import 'package:voucherize/features/auth/core/stores/auth_store.dart';
import 'package:voucherize/core/local_storage/client_user_token_data/client_user_token_data.prefs.dart';
import 'package:voucherize/models/auth/client-user-token-data.model.dart';
import 'package:voucherize/features/cart/core/stores/cart_store.dart';
import 'package:voucherize/features/cart/presentation/components/cart_drawer.dart';
import 'dart:math' as math;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:voucherize/features/login/core/stores/login_store.dart';

/// App-wide navigation header matching the public layout.
class NavHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const NavHeader({super.key, this.title = ''});

  bool _isRouteActive(BuildContext context, String routeName) {
    final router = AutoRouter.of(context);
    final current = router.current;
    final currentName = current.name;
    return currentName == routeName;
  }

  @override
  Widget build(BuildContext context) {
    final sl = GetIt.instance;
    AuthStore? authStore;
    try {
      authStore = sl<AuthStore>();
    } catch (_) {
      authStore = null;
    }

    final loggedIn = authStore?.loginResponse != null ||
        ClientUserTokenDataPrefs.get() != null;
    final ClientUserTokenData? userData = ClientUserTokenDataPrefs.get();

    final isMobile = MediaQuery.of(context).size.width < 900;

    Widget buildActionsRow() {
      final isOnHome = _isRouteActive(context, HomeRoute.name);
      final isOnMyVouchers = _isRouteActive(context, MyVouchersRoute.name);

      return Row(
        children: [
          // Catalog button: show white bg when on home (custom to avoid DsButton default fill)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isOnHome ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () {
                if (!isOnHome) AutoRouter.of(context).pushNamed('/');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: DsText(
                  text: 'Catálogo de Serviços',
                  variant: DsTextVariant.baseBold,
                  color: isOnHome ? const Color.fromRGBO(35, 95, 231, 1) : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Meus cupons: show white bg and dark icon when active
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isOnMyVouchers ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
                child: InkWell(
              onTap: () {
                if (!isOnMyVouchers) {
                  AutoRouter.of(context).push(const MyVouchersRoute());
                }
              },
              child: Row(
                children: [
                  Icon(Icons.receipt_long, color: isOnMyVouchers ? const Color.fromRGBO(35, 95, 231, 1) : Colors.white),
                  const SizedBox(width: 6),
                  DsText(text: 'Meus cupons', variant: DsTextVariant.base, color: isOnMyVouchers ? const Color.fromRGBO(35, 95, 231, 1) : Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (!loggedIn)
            TextButton(
              onPressed: () => AutoRouter.of(context).pushNamed('/login'),
              child: const DsText(text: 'Login', variant: DsTextVariant.base, color: Colors.white),
            )
          else
            _buildProfileButton(userData, authStore, context),
          const SizedBox(width: 8),
          Builder(builder: (ctx) {
            final cart = GetIt.instance<CartStore>();
            return Observer(builder: (_) {
              final count = cart.items.length;
              final isOpen = cart.isDrawerOpen;
              return GestureDetector(
                onTap: () {
                  try {
                    if (cart.isDrawerOpen) {
                      // close drawer
                      try { Navigator.of(ctx).pop(); } catch (_) {}
                      cart.setDrawerOpen(false);
                    } else {
                      cart.setDrawerOpen(true);
                      // If the current Scaffold has an endDrawer, open it. Otherwise show a right-side dialog with the cart.
                      try {
                        final scaffoldWidget = ctx.findAncestorWidgetOfExactType<Scaffold>();
                        if (scaffoldWidget != null && scaffoldWidget.endDrawer != null) {
                          Scaffold.of(ctx).openEndDrawer();
                        } else {
                          // show a right-side sliding dialog with the CartDrawer
                          showGeneralDialog(
                            context: ctx,
                            barrierDismissible: true,
                            barrierLabel: 'Cart',
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Material(
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width: math.max(MediaQuery.of(ctx).size.width * 0.4, 320.0),
                                    child: const CartDrawer(),
                                  ),
                                ),
                              );
                            },
                            transitionBuilder: (context, animation, secondaryAnimation, child) {
                              final offsetAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation);
                              return SlideTransition(position: offsetAnimation, child: child);
                            },
                          );
                        }
                      } catch (_) {}
                    }
                  } catch (_) {}
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOpen ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(Icons.shopping_cart, color: isOpen ? const Color.fromRGBO(35, 95, 231, 1) : Colors.white),
                          if (count > 0)
                            Positioned(
                              right: -8,
                              top: -8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle),
                                child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(width: 8),
                      DsText(text: 'Carrinho', variant: DsTextVariant.baseBold, color: isOpen ? const Color.fromRGBO(35, 95, 231, 1) : Colors.white),
                    ],
                  ),
                ),
              );
            });
          }),
        ],
      );
    }

    return Material(
      color: const Color.fromRGBO(35, 95, 231, 1),
      elevation: 2,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: preferredSize.height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                if (isMobile)
                  IconButton(
                    onPressed: () => _openMobileMenu(context, loggedIn, userData, authStore),
                    icon: const Icon(Icons.menu, color: Colors.white),
                  ),
                const SizedBox(width: 6),
                const Icon(Icons.shield, color: Colors.white),
                const SizedBox(width: 10),
                if (!isMobile)
                  const DsText(text: 'Sistema Público de Arrecadação', variant: DsTextVariant.baseRegular, color: Colors.white)
                else
                  const DsText(text: 'Portal do Cidadão', variant: DsTextVariant.baseBold, color: Colors.white)
              ]),

              if (!isMobile) buildActionsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton(ClientUserTokenData? userData, AuthStore? authStore, BuildContext context) {
    return PopupMenuButton<int>(
      offset: const Offset(0, 50),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) => [
        //PopupMenuItem<int>(value: NavItem.profile.value, child: const Text('Meu Perfil', style: TextStyle(color: Color.fromRGBO(35, 95, 231, 1), fontWeight: FontWeight.w700))),
        PopupMenuItem<int>(value: NavItem.myVouchers.value, child: const Text('Meus Cupons / Vouchers')),
        PopupMenuItem<int>(value: NavItem.payments.value, child: const Text('Histórico de Pagamentos')),
        //PopupMenuItem<int>(value: NavItem.settings.value, child: const Text('Configurações')),
        const PopupMenuDivider(),
        PopupMenuItem<int>(value: NavItem.logout.value, child: const Text('Sair / Logout')),
      ],
      onSelected: (v) async {
        if (v == NavItem.myVouchers.value) {
          final router = AutoRouter.of(context);
          if (!_isRouteActive(context, MyVouchersRoute.name)) {
            router.push(const MyVouchersRoute());
          }
        }
        if (v == NavItem.payments.value) {
          final router = AutoRouter.of(context);
          if (!_isRouteActive(context, PurchaseHistoryRoute.name)) {
            router.push(const PurchaseHistoryRoute());
          }
        }
        if (v == NavItem.settings.value) {
          final router = AutoRouter.of(context);
          if (!_isRouteActive(context, SettingsMenuRoute.name)) {
            router.push(const SettingsMenuRoute());
          }
        }
        if (v == NavItem.profile.value) {
          final router = AutoRouter.of(context);
          if (!_isRouteActive(context, ProfileMenuRoute.name)) {
            router.push(const ProfileMenuRoute());
          }
        }
        if (v == NavItem.logout.value) {
          // Clear persisted token
          await ClientUserTokenDataPrefs.set(null);

          // Clear auth store state
          try {
            await authStore?.logout();
          } catch (_) {}

          // Also clear login store state (if registered)
          try {
            final loginStore = GetIt.instance<LoginStore>();
            try {
              loginStore.loginResponse = null;
            } catch (_) {}
            try {
              loginStore.error = null;
            } catch (_) {}
            try {
              loginStore.emailController.clear();
              loginStore.passwordController.clear();
            } catch (_) {}
          } catch (_) {}

          // Navigate to home (public) route
          AutoRouter.of(context).pushNamed('/');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          CircleAvatar(radius: 14, backgroundColor: const Color(0xFFEEF2FF), child: Text((userData?.name ?? 'U').substring(0, 1), style: const TextStyle(color: Color(0xFF004080), fontWeight: FontWeight.w700))),
          const SizedBox(width: 8),
          DsText(text: '${userData?.name ?? 'Unknown'} ${userData?.secondName ?? ''}'.trim(), variant: DsTextVariant.baseBold, color: const Color.fromRGBO(35, 95, 231, 1)),
        ]),
      ),
    );
  }

  void _openMobileMenu(BuildContext context, bool loggedIn, ClientUserTokenData? userData, AuthStore? authStore) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(leading: const Icon(Icons.home), title: const Text('Catálogo de Serviços'), onTap: () { Navigator.of(context).pop(); AutoRouter.of(context).pushNamed('/'); }),
              ListTile(leading: const Icon(Icons.receipt_long), title: const Text('Meus cupons'), onTap: () { Navigator.of(context).pop(); final router = AutoRouter.of(context); if (!_isRouteActive(context, MyVouchersRoute.name)) { router.push(const MyVouchersRoute()); } }),
              if (!loggedIn) ListTile(leading: const Icon(Icons.login), title: const Text('Login'), onTap: () { Navigator.of(context).pop(); AutoRouter.of(context).pushNamed('/login'); }),
              if (loggedIn) ListTile(leading: const Icon(Icons.person), title: Text(userData?.name ?? 'Meu Perfil'), onTap: () {}),
              const Divider(),
              ListTile(leading: const Icon(Icons.shopping_cart), title: const Text('Carrinho'), onTap: () {}),
            ]),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(98);
}
