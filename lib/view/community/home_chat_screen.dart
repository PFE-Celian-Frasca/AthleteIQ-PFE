import 'package:athlete_iq/app/provider/nav_bar_provider.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/group/group_repository.dart';
import 'package:athlete_iq/utils/routing/custom_popup_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:athlete_iq/resources/components/Button/custom_floating_button.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/view/community/chat-page/components/chat_widget.dart';
import 'package:athlete_iq/view/community/components/no_group_component.dart';
import 'package:athlete_iq/view/community/create-group-screen/create_group_screen.dart';
import 'package:athlete_iq/view/community/home_chat_controller.dart';

class HomeChatScreen extends ConsumerStatefulWidget {
  const HomeChatScreen({super.key});

  @override
  HomeChatScreenState createState() => HomeChatScreenState();
}

class HomeChatScreenState extends ConsumerState<HomeChatScreen> {
  @override
  void initState() {
    super.initState();
    final userId = ref.read(authRepositoryProvider).currentUser?.uid ?? "";
    if (userId.isNotEmpty) {
      ref.read(homeChatControllerProvider.notifier).loadGroups(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid ?? "";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Communauté",
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).go('/groups/search');
            },
            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
        hasBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChatsStream(uid: userId),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 90.h),
        child: CustomFloatingButton(
          onPressed: () async {
            ref.read(showNavBarProvider.notifier).state = false;
            await Navigator.of(context)
                .push(
                  CustomPopupRoute(
                    builder: (BuildContext context) => const CreateGroupScreen(),
                  ),
                )
                .then((value) => ref.read(showNavBarProvider.notifier).state = true);
            ref.read(homeChatControllerProvider.notifier).refreshGroups(userId);
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          icon: Icons.add,
          iconColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class ChatsStream extends ConsumerWidget {
  const ChatsStream({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupRepository = ref.watch(groupRepositoryProvider);

    return StreamBuilder<List<GroupModel>>(
      stream: groupRepository.getGroupsStream(uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final groupsList = snapshot.data!;
          // Trier les groupes par timeSent en ordre décroissant
          groupsList.sort((a, b) => b.timeSent.compareTo(a.timeSent));

          return ListView.builder(
            itemCount: groupsList.length,
            itemBuilder: (context, index) {
              final group = groupsList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ChatWidget(
                  group: group,
                  onTap: () {
                    GoRouter.of(context).go("/groups/chat/${group.groupId}");
                  },
                ),
              );
            },
          );
        }
        return noGroupWidget(ref, context);
      },
    );
  }
}
