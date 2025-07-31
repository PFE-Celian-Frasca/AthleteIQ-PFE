import 'dart:async';
import 'dart:ui'; // pour PlatformDispatcher

import 'package:athlete_iq/services/firebase_notification_service.dart';
import 'package:athlete_iq/theme.dart';
import 'package:athlete_iq/utils/routing/app_router.dart';
import 'package:athlete_iq/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';


Future<void> main() async {
  await runZonedGuarded<Future<void>>(() async {
    // Tout ce qui suit se fait dans la même zone que runApp
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: '.env');
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Crashlytics : erreurs Flutter
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Crashlytics : erreurs non-Flutter / Zone current isolate
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true; // erreur gérée
    };

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await initializeDateFormatting('fr_FR', null);

    // (Sur Android la permission n'est pas requise, mais cet appel est safe et idempotent)
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) {
    // Dernière barrière pour Crashlytics
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    // On peut retirer le splash ici (ou après la 1ʳᵉ frame via postFrameCallback)
    FlutterNativeSplash.remove();

    // Init notif locales (si tu en as besoin dès le boot)
    FirebaseNotificationService.initialize(context);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'AthleteIQ',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: goRouter,
      ),
    );
  }
}
