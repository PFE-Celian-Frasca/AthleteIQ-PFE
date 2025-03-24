import 'dart:convert';

import 'package:athlete_iq/ui/providers/cache_provider.dart';
import 'package:athlete_iq/utils/routes/root.dart';
import 'package:athlete_iq/utils/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_theme_plus/json_theme_plus.dart';
import 'firebase_options.dart';


Future<void> main() async {
  SchemaValidator.enabled = false;
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  await Hive.initFlutter();
  runApp(ProviderScope(child: MyApp(theme: theme,)));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'AthleteIQ',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: InitRoute.route,
      onGenerateRoute: AppRouter.onNavigate,
    );
  }
}

class InitRoute extends ConsumerStatefulWidget {
  const InitRoute({Key? key}) : super(key: key);
  static const String route = "/";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InitRouteState();
}

class _InitRouteState extends ConsumerState<InitRoute> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await ref.read(cacheProvider.future);
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Root.route,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
  }
