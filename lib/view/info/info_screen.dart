import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/view/info/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/top_info.dart';
import 'components/middle_nav_component.dart';
import 'courses_list_screen.dart';
import 'fav-list/fav_list_screen.dart';
import 'friend-list/friends_list_screen.dart';

class InfoScreen extends HookConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('Utilisateur non connecté.'));
    }

    final List<Widget> widgetOptions = [
      const CoursesListScreen(),
      const FavListScreen(),
      const FriendsListScreen(),
    ];

    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        body: Column(
          children: [
            BuildTopInfo(
              userId: userId,
            ),
            buildMiddleNavInfo(ref),
            Expanded(
              child: widgetOptions.elementAt(selectedIndex),
            ),
          ],
        ),
      ),
    );
  }
}
