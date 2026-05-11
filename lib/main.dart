import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tsdtech_client_sdk/core/guards/auth.guard.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';
import 'package:tsdtech_client_sdk/core/service_locator.dart';
import 'package:tsdtech_client_sdk/core/utils/administrator_resolver.dart';
import 'package:tsdtech_client_sdk/core/components/loading_splash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app immediately and perform async startup inside the widget tree
  runApp(const _AppInitializer());
}

/// Minimal initializer that runs the async startup sequence and shows
/// a loading indicator while the app initializes.
class _AppInitializer extends StatelessWidget {
  const _AppInitializer();

  Future<AppRouter> _init() async {
    await SharedPrefsHelper.init();
    await resolveAndCacheAdministrator();
    await setupLocator();
    return AppRouter(authGuard: AuthGuard());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppRouter>(
      future: _init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingSplash();
        }

        final router = snapshot.data!;
        return VoucherizeApp(appRouter: router);
      },
    );
  }
}

class VoucherizeApp extends StatelessWidget {
  final AppRouter appRouter;

  const VoucherizeApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      title: 'SPA Portal do Cidadão',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color.fromRGBO(243, 243, 243, 1),
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),
    );
  }
}
