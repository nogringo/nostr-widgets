import 'package:demo_app/app_routes.dart';
import 'package:demo_app/controllers/repository.dart';
import 'package:demo_app/get_database.dart';
import 'package:demo_app/middlewares/auth_middleware.dart';
import 'package:demo_app/screens/home_screen.dart';
import 'package:demo_app/screens/profile_screen.dart';
import 'package:demo_app/screens/signin_screen.dart';
import 'package:demo_app/screens/switch_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/functions/functions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nostr_widgets/l10n/app_localizations.dart' as nostr_widgets;
import 'package:sembast_cache_manager/sembast_cache_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ndk = Ndk(
    NdkConfig(
      eventVerifier: Bip340EventVerifier(),
      cache: SembastCacheManager(await getDatabase()),
    ),
  );
  Get.put(ndk);

  await nRestoreAccounts(ndk);

  Get.put(Repository());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        nostr_widgets.AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('es')],
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: AppRoutes.profile,
      getPages: [
        GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
        GetPage(name: AppRoutes.signIn, page: () => const SigninScreen()),
        GetPage(
          name: AppRoutes.switchAccount,
          page: () => const SwitchAccountScreen(),
        ),
        GetPage(
          name: AppRoutes.profile,
          page: () => const ProfileScreen(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}
