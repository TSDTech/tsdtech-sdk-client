import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/guards/auth.guard.dart';
import 'package:tsdtech_client_sdk/core/utils/empty_router_page.dart';
import 'package:tsdtech_client_sdk/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:tsdtech_client_sdk/features/settings_menu/presentation/screens/settings_menu_screen.dart';
import 'package:tsdtech_client_sdk/features/login/presentation/screens/forgot_password_screen.dart';
import 'package:tsdtech_client_sdk/features/login/presentation/screens/login_screen.dart';
import 'package:tsdtech_client_sdk/features/profile_menu/presentation/screens/profile_menu_screen.dart';
import 'package:tsdtech_client_sdk/features/purchase_history/presentation/screens/purchase_history_screen.dart';
import 'package:tsdtech_client_sdk/features/services_catalog/presentation/screens/home_screen.dart';
import 'package:tsdtech_client_sdk/features/signup/presentation/screens/signup_person_screen.dart';
import 'package:tsdtech_client_sdk/features/vouchers/presentation/screens/my_vouchers_screen.dart';
import 'package:tsdtech_client_sdk/features/vouchers/presentation/screens/my_vouchers_form_screen.dart';
import 'package:tsdtech_client_sdk/features/vouchers/presentation/screens/provider_request_finished_screen.dart';
import 'package:tsdtech_client_sdk/features/vouchers/presentation/screens/provider_request_form_screen.dart';
import 'package:tsdtech_client_sdk/features/vouchers/presentation/screens/provider_request_qrcode_screen.dart';
import 'package:tsdtech_client_sdk/features/vouchers/presentation/screens/voucher_qrcode_screen.dart';


// Importa todos os módulos de features
import 'package:tsdtech_client_sdk/main.module.dart';
part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.authGuard});

  final AuthGuard authGuard;

  static final MainModule _mainModule = MainModule();

  @override
  List<AutoRoute> get routes => [
        ..._mainModule.collectRoutes(),
      ];
}
