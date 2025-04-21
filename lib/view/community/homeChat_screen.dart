import 'package:athlete_iq/app/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/providers/groupe/list/group_list_provider.dart';
import 'package:athlete_iq/resources/components/Button/CustomFloatingButton.dart';
import 'package:athlete_iq/resources/components/CustomAppBar.dart';
import 'package:athlete_iq/utils/routes/customPopupRoute.dart';
import 'components/group_tile.dart';
import 'components/no_group_component.dart';
import 'create-group-screen/createGroup_screen.dart';

class HomeChatScreen extends ConsumerStatefulWidget {
  const HomeChatScreen({super.key});

  @override
  _HomeChatScreenState createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends ConsumerState<HomeChatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(globalProvider.select((state) => state.userState
          .maybeWhen(orElse: () => null, loaded: (user) => user)));
      if (user != null) {
        ref.read(groupListProvider.notifier).loadUserGroups(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupListProvider);
    final user = ref.watch(globalProvider.select((state) =>
        state.userState.maybeWhen(orElse: () => null, loaded: (user) => user)));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Communauté",
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).go('/groups/search');
            },
            icon: Icon(Icons.search,
                color: Theme.of(context).colorScheme.onBackground),
          ),
        ],
        hasBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(groupListProvider.notifier).loadUserGroups(user!.id),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
          child: groupState.when(
            initial: () => const Text('Pull down to load your groups.'),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (groups) => groups.isEmpty
                ? noGroupWidget(ref, context)
                : ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) =>
                        groupTile(groups[index], context, ref),
                  ),
            error: (error) => Text('Error: $error'),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 90.h),
        child: CustomFloatingButton(
          onPressed: () async {
            ref.read(showNavBarProvider.notifier).state = false;
            await Navigator.of(context)
                .push(
                  CustomPopupRoute(
                    builder: (BuildContext context) =>
                        const CreateGroupScreen(),
                  ),
                )
                .then((value) =>
                    ref.read(showNavBarProvider.notifier).state = true);
            ref.read(groupListProvider.notifier).loadUserGroups(user!.id);
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          icon: Icons.add,
          iconColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
