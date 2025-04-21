import 'package:athlete_iq/view/info/provider/all_parcours_list/combined_parcours_provider.dart';
import 'package:athlete_iq/view/info/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/TopInfo.dart';
import 'components/middleNavComponent.dart';
import 'courses_list_screen.dart';
import 'fav-list/fav_list_screen.dart';
import 'friend-list/friends_list_screen.dart';

class InfoScreen extends HookConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);

    useEffect(() {
      Future.microtask(() async {
        await ref.read(combinedParcoursProvider.notifier).getFavorites();
        await ref.read(combinedParcoursProvider.notifier).getList();
      });
      return null;
    }, const []);

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
            buildTopInfo(context, ref),
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
