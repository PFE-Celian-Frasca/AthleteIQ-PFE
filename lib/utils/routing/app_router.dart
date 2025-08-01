import 'package:athlete_iq/app/main_screen.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/view/onboarding/onboarding_screen.dart';
import 'package:athlete_iq/view/auth/email_verify_page.dart';
import 'package:athlete_iq/view/auth/forgot_password_screen.dart';
import 'package:athlete_iq/view/auth/login_screen.dart';
import 'package:athlete_iq/view/auth/signup_screen.dart';
import 'package:athlete_iq/view/community/chat-page/chat_screen.dart';
import 'package:athlete_iq/view/community/chat-page/components/group_info.dart';
import 'package:athlete_iq/view/community/home_chat_screen.dart';
import 'package:athlete_iq/view/community/search-screen/search_screen.dart';
import 'package:athlete_iq/view/home_screen/home_screen.dart';
import 'package:athlete_iq/view/info/info_screen.dart';
import 'package:athlete_iq/view/onboarding/provider/onboarding_repository.dart';
import 'package:athlete_iq/view/parcour-detail/parcour_details_screen.dart';
import 'package:athlete_iq/view/parcour-detail/update_parcour_screen.dart';
import 'package:athlete_iq/view/register_parcours_screen/register_screen.dart';
import 'package:athlete_iq/view/settings/privacy/privacy_policy_screen.dart';
import 'package:athlete_iq/view/settings/profil/profile_screen.dart';
import 'package:athlete_iq/view/settings/settings_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:athlete_iq/utils/routing/app_startup.dart';
import 'package:athlete_iq/utils/routing/go_router_refresh_stream.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

@riverpod
GoRouter goRouter(Ref ref) {
  // rebuild GoRouter when app startup state changes
  final appStartupState = ref.watch(appStartupProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // If the app is still initializing, show the /startup route
      if (appStartupState.isLoading || appStartupState.hasError) {
        return '/startup';
      }
      final onboardingRepository = ref.read(onboardingRepositoryProvider).requireValue;
      final didCompleteOnboarding = onboardingRepository.isOnboardingComplete();
      final path = state.uri.path;
      if (!didCompleteOnboarding) {
        if (path != '/onboarding') {
          return '/onboarding';
        }
        return null;
      }
      final isLoggedIn = authRepository.currentUser != null;
      final isEmailVerified = authRepository.currentUser?.emailVerified ?? false;
      if (isLoggedIn) {
        if (!isEmailVerified && path != '/email-verify') {
          return '/email-verify';
        }
        if (path.startsWith('/startup') ||
            path.startsWith('/onboarding') ||
            path.startsWith('/login')) {
          return '/home';
        }
      } else {
        if (path.startsWith('/startup') ||
            path.startsWith('/onboarding') ||
            path.startsWith('/home') ||
            path.startsWith('/info') ||
            path.startsWith('/groups')) {
          return '/login';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => MaterialPage(child: SignupScreen()),
      ),
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
      GoRoute(
        path: '/startup',
        pageBuilder: (context, state) => NoTransitionPage(
          child: AppStartupWidget(
            onLoaded: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const MaterialPage(child: HomeScreen()),
            routes: [
              GoRoute(
                  path: 'parcours/details/:parcoursId',
                  builder: (context, state) {
                    final parcoursId = state.pathParameters['parcoursId']!;
                    return ParcourDetails(parcourId: parcoursId);
                  },
                  parentNavigatorKey: rootNavigatorKey,
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) {
                        final parcourDatas = state.extra as String;
                        return UpdateParcourScreen(
                          parcourId: parcourDatas,
                        );
                      },
                      parentNavigatorKey: rootNavigatorKey,
                    ),
                  ]),
            ],
          ),
          GoRoute(
            path: '/groups',
            pageBuilder: (context, state) => const MaterialPage(child: HomeChatScreen()),
            routes: [
              GoRoute(
                path: 'search',
                builder: (context, state) => const SearchScreen(),
                parentNavigatorKey: rootNavigatorKey,
              ),
              GoRoute(
                path: 'chat/:groupId',
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId']!;
                  return ChatScreen(
                    groupId: groupId,
                  );
                },
                parentNavigatorKey: rootNavigatorKey,
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) {
                      final groupId = state.pathParameters['groupId']!;
                      return GroupInfo(groupId);
                    },
                    parentNavigatorKey: rootNavigatorKey,
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/info',
            pageBuilder: (context, state) => const MaterialPage(child: InfoScreen()),
            routes: [
              GoRoute(
                path: 'settings',
                pageBuilder: (context, state) => const MaterialPage(child: SettingsScreen()),
                parentNavigatorKey: rootNavigatorKey,
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const ProfileScreen(),
                    parentNavigatorKey: rootNavigatorKey,
                  ),
                  GoRoute(
                    path: 'privacy',
                    builder: (context, state) => const PrivacySettingsScreen(),
                    parentNavigatorKey: rootNavigatorKey,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
