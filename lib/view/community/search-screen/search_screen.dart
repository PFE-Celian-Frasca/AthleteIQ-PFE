import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/providers/user/user_provider.dart';
import 'package:athlete_iq/utils/stringCapitalize.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/resources/components/CustomAppBar.dart';
import 'package:athlete_iq/view/community/search-screen/provider/search_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../resources/components/InputField/CustomInputField.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final tabController = useTabController(initialLength: 2);
    final currentUser = ref.watch(globalProvider.select((state) =>
        state.userState.maybeWhen(orElse: () => null, loaded: (user) => user)));

    void refresh(WidgetRef ref) {
      if (searchController.text.isEmpty) {
        ref.read(userSearchProvider.notifier).searchUsers('');
        ref.read(groupSearchProvider.notifier).searchGroups('');
      } else {
        ref
            .read(userSearchProvider.notifier)
            .searchUsers(searchController.text);
        ref
            .read(groupSearchProvider.notifier)
            .searchGroups(searchController.text);
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Recherche",
        hasBackButton: true,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            CustomInputField(
              context: context,
              label: "Rechercher...",
              controller: searchController,
              icon: Icons.search,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  refresh(ref);
                },
              ),
              onChanged: (value) {
                refresh(ref);
              },
            ),
            TabBar(
              controller: tabController,
              tabs: const [Tab(text: 'Utilisateurs'), Tab(text: 'Groupes')],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _buildUserList(ref, context, currentUser),
                  _buildGroupList(ref, context, currentUser),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(
      WidgetRef ref, BuildContext context, UserModel? currentUser) {
    final userState = ref.watch(userSearchProvider);
    if (userState.loading && userState.filteredUsers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: userState.filteredUsers.length,
      itemBuilder: (context, index) {
        final UserModel user = userState.filteredUsers[index];
        if (user.id == currentUser?.id) return const SizedBox.shrink();
        return _buildUserTile(user, context, ref, currentUser);
      },
    );
  }

  Widget _buildGroupList(
      WidgetRef ref, BuildContext context, UserModel? currentUser) {
    final groupState = ref.watch(groupSearchProvider);
    if (groupState.loading && groupState.filteredGroups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: groupState.filteredGroups.length,
      itemBuilder: (context, index) {
        final GroupModel group = groupState.filteredGroups[index];
        if (group.admin == currentUser?.id) return const SizedBox.shrink();
        return _buildGroupTile(group, context, ref, currentUser);
      },
    );
  }

  Widget _buildUserTile(UserModel user, BuildContext context, WidgetRef ref,
      UserModel? currentUser) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.image),
        radius: 25.r,
      ),
      title: Text(user.pseudo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text("Utilisateur",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall),
      trailing: buildTrailingIcon(true, user, ref, currentUser),
    );
  }

  Widget _buildGroupTile(GroupModel group, BuildContext context, WidgetRef ref,
      UserModel? currentUser) {
    return ListTile(
      leading: group.groupIcon != null && group.groupIcon!.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(group.groupIcon!),
              radius: 25.r,
            )
          : CircleAvatar(
              radius: 25.r,
              child: Text(group.groupName.initials()),
            ),
      title:
          Text(group.groupName, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(
        "Groupe",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: buildTrailingIcon(false, group, ref, currentUser),
    );
  }

  Widget buildTrailingIcon(
      bool isUser, dynamic data, WidgetRef ref, UserModel? currentUser) {
    return isUser && currentUser!.sentFriendRequests.contains(data?.id)
        ? Text('En attente', style: TextStyle(fontSize: 13.sp))
        : IconButton(
            onPressed: () async {
              if (isUser) {
                if (data.friends.contains(currentUser?.id)) {
                  ref
                      .read(userProvider.notifier)
                      .removeFriend(user: data, currentUser: currentUser!);
                } else if (data.receivedFriendRequests
                    .contains(currentUser?.id)) {
                  ref.read(userProvider.notifier).acceptFriendRequest(
                      user: data, currentUser: currentUser!);
                } else {
                  await ref
                      .read(userProvider.notifier)
                      .updateUserProfile(currentUser!);
                  ref
                      .read(globalProvider.select((value) => value.userState))
                      .maybeWhen(
                        orElse: () {},
                        loaded: (user) {
                          currentUser = user;
                          if (currentUser!.sentFriendRequests.contains(data.id))
                            return;
                          ref.read(userProvider.notifier).requestFriend(
                              user: data, currentUser: currentUser!);
                        },
                      );
                }
              } else {
                print(
                    "member of groups: ${data.members.contains(currentUser?.id)}");
                if (data.members.contains(currentUser?.id)) {
                  try {
                    await ref
                        .read(groupActionsProvider.notifier)
                        .leaveGroup(group: data, currentUser: currentUser!);
                  } catch (e) {
                    return;
                  }
                } else {
                  print("join group");
                  try {
                    await ref
                        .read(groupActionsProvider.notifier)
                        .joinGroup(group: data, currentUser: currentUser!);
                    print('return after join group');
                    print('current user: ${currentUser?.id}');
                    final updatedMembers = List<String>.from(data.members)
                      ..add(currentUser!.id);
                    final updatedGroup = data.copyWith(members: updatedMembers);
                  } catch (e) {
                    return;
                  }
                }
              }
            },
            icon: Icon(
              isUser
                  ? data.friends.contains(currentUser?.id)
                      ? MdiIcons.accountRemoveOutline
                      : data.receivedFriendRequests.contains(currentUser?.id)
                          ? MdiIcons.accountCheckOutline
                          : MdiIcons.accountPlusOutline
                  : data.members.contains(currentUser?.id)
                      ? MdiIcons.exitRun
                      : MdiIcons.accountMultiplePlus,
              size: 24.r,
            ),
          );
  }
}
