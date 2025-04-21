import 'package:athlete_iq/app/main_screen.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/services/shared_preferences_service.dart';
import 'package:athlete_iq/view/onboarding_screen.dart';
import 'package:athlete_iq/view/auth/email_verify_page.dart';
import 'package:athlete_iq/view/auth/forgot_password_screen.dart';
import 'package:athlete_iq/view/auth/login_screen.dart';
import 'package:athlete_iq/view/auth/signup_screen.dart';
import 'package:athlete_iq/view/community/chat-page/chat_page.dart';
import 'package:athlete_iq/view/community/chat-page/components/group_info.dart';
import 'package:athlete_iq/view/community/homeChat_screen.dart';
import 'package:athlete_iq/view/community/search-screen/search_screen.dart';
import 'package:athlete_iq/view/home_screen/home_screen.dart';
import 'package:athlete_iq/view/info/info_screen.dart';
import 'package:athlete_iq/view/parcour-detail/parcour_details_screen.dart';
import 'package:athlete_iq/view/parcour-detail/update_parcour_screen.dart';
import 'package:athlete_iq/view/register_parcours_screen/register_screen.dart';
import 'package:athlete_iq/view/settings/profil/profile_screen.dart';
import 'package:athlete_iq/view/settings/settings_screen.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState =
      ref.watch(globalProvider.select((state) => state.authState));

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/email-verify',
        builder: (context, state) => const EmailVerifyScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                  path: 'parcours/details/:parcoursId',
                  builder: (context, state) {
                    final parcoursId = state.pathParameters['parcoursId']!;
                    return ParcourDetails(parcourId: parcoursId);
                  },
                  parentNavigatorKey: _rootNavigatorKey,
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) {
                        final parcourDatas = state.extra as ParcoursWithGPSData;
                        return UpdateParcourScreen(
                            /* parcourDatas: parcourDatas,*/
                            );
                      },
                      parentNavigatorKey: _rootNavigatorKey,
                    ),
                  ]),
            ],
          ),
          GoRoute(
            path: '/groups',
            builder: (context, state) => const HomeChatScreen(),
            routes: [
              GoRoute(
                path: 'search',
                builder: (context, state) => SearchScreen(),
                parentNavigatorKey: _rootNavigatorKey,
              ),
              GoRoute(
                path: 'chat/:groupId',
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId']!;
                  return ChatPage(groupId);
                },
                parentNavigatorKey: _rootNavigatorKey,
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) {
                      final groupId = state.pathParameters['groupId']!;
                      return GroupInfo(groupId);
                    },
                    parentNavigatorKey: _rootNavigatorKey,
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/info',
            builder: (context, state) => const InfoScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                builder: (context, state) => const SettingsScreen(),
                parentNavigatorKey: _rootNavigatorKey,
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const ProfileScreen(),
                    parentNavigatorKey: _rootNavigatorKey,
                  ),
                  GoRoute(
                    path: 'a-propos-de-nous',
                    builder: (context, state) => const ProfileScreen(),
                    parentNavigatorKey: _rootNavigatorKey,
                  ),
                  GoRoute(
                    path: 'conditions-utilisation',
                    builder: (context, state) => const ProfileScreen(),
                    parentNavigatorKey: _rootNavigatorKey,
                  ),
                  GoRoute(
                    path: 'politique-confidentialite',
                    builder: (context, state) => const ProfileScreen(),
                    parentNavigatorKey: _rootNavigatorKey,
                  ),
                  // Autres sous-routes de réglages
                ],
              ),
              // Ajoutez d'autres sous-routes pour Info si nécessaire
            ],
          ),
        ],
      ),
    ],
    // Guards pour gérer la redirection basée sur l'état d'authentification
    redirect: (context, state) async {
      final isLoggedIn = authState.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
      //TODO: Ajouter un état pour vérifier si l'utilisateur a vu l'onboarding
      final hasSeenOnboarding =
          await ref.read(sharedPreferencesServiceProvider).getBool("seen") ??
              false;

      final isLoginOrRegister = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password';
      if (!hasSeenOnboarding) {
        return '/onboarding';
      }

      if (!isLoggedIn && !isLoginOrRegister) {
        print(isLoginOrRegister);
        print("ok");
        return '/login';
      } else if (isLoggedIn &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/signup')) {
        return '/';
      }

      return null;
    },
  );
});
