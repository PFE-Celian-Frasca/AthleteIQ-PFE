import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/view/info/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:athlete_iq/view/info/components/top_info.dart';
import 'package:athlete_iq/view/info/components/middle_nav_component.dart';
import 'package:athlete_iq/view/info/courses_list_screen.dart';
import 'package:athlete_iq/view/info/fav-list/fav_list_screen.dart';
import 'package:athlete_iq/view/info/friend-list/friends_list_screen.dart';

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
        body: FocusTraversalGroup(
          child: Column(
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
      ),
    );
  }
}
