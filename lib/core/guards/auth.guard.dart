import 'package:auto_route/auto_route.dart';
import 'package:voucherize/core/local_storage/client_user_token_data/client_user_token_data.prefs.dart';
import 'package:voucherize/core/router/router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final authData = ClientUserTokenDataPrefs.get();

    final isLoggedIn = authData?.isTokenExpired() == false;

    final bool? requiresAuth = resolver.route.meta['requiresAuth'];

    if (requiresAuth == true && !isLoggedIn) {
      // Check if we're coming from an invite link and preserve the token
      final token = resolver.route.queryParams.optString('token');
      if (token != null && token.isNotEmpty) {
        router.replace(LoginRoute(termsToken: token));
      } else {
        router.replace(LoginRoute());
      }
      return;
    }


    if (requiresAuth == false && isLoggedIn) {
      router.replace(const EmptyRouterRoute());
      return;
    }

    // requiresAuth == null → rota não define regra → deixa passar
    resolver.next();
  }
}
