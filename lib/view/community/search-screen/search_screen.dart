import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/string_capitalize.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/view/community/search-screen/provider/search_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:athlete_iq/resources/components/InputField/custom_input_field.dart';
import 'package:athlete_iq/view/community/search-screen/search_controller.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final tabController = useTabController(initialLength: 2);
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid ?? "";
    final currentUserAsync = ref.watch(userStateChangesProvider(userId));

    return currentUserAsync.when(
      data: (currentUser) {
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
                  keyboardType: TextInputType.text,
                  icon: Icons.search,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      ref.read(searchControllerProvider.notifier).refresh('');
                    },
                  ),
                  onChanged: (value) {
                    ref.read(searchControllerProvider.notifier).refresh(value);
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erreur: $error')),
    );
  }

  Widget _buildUserList(WidgetRef ref, BuildContext context, UserModel? currentUser) {
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

  Widget _buildGroupList(WidgetRef ref, BuildContext context, UserModel? currentUser) {
    final groupState = ref.watch(groupSearchProvider);
    if (groupState.loading && groupState.filteredGroups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: groupState.filteredGroups.length,
      itemBuilder: (context, index) {
        final GroupModel group = groupState.filteredGroups[index];
        if (group.adminsUIDs.contains(currentUser?.id)) {
          return const SizedBox.shrink();
        }
        return _buildGroupTile(group, context, ref, currentUser);
      },
    );
  }

  Widget _buildUserTile(
      UserModel user, BuildContext context, WidgetRef ref, UserModel? currentUser) {
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

  Widget _buildGroupTile(
      GroupModel group, BuildContext context, WidgetRef ref, UserModel? currentUser) {
    return ListTile(
      leading: group.groupImage.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(group.groupImage),
              radius: 25.r,
            )
          : CircleAvatar(
              radius: 25.r,
              child: Text(group.groupName.initials()),
            ),
      title: Text(group.groupName, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(
        "Groupe",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: buildTrailingIcon(false, group, ref, currentUser),
    );
  }

  Widget buildTrailingIcon(bool isUser, dynamic data, WidgetRef ref, UserModel? currentUser) {
    if (currentUser == null) {
      return const SizedBox.shrink(); // Or any placeholder
    }
    return isUser && currentUser.sentFriendRequests.contains(data.id)
        ? Text('En attente', style: TextStyle(fontSize: 13.sp))
        : IconButton(
            onPressed: () async {
              if (isUser) {
                await ref
                    .read(searchControllerProvider.notifier)
                    .handleUserAction(data, currentUser);
              } else {
                await ref
                    .read(searchControllerProvider.notifier)
                    .handleGroupAction(data, currentUser);
              }
            },
            icon: Icon(
              isUser
                  ? data.friends.contains(currentUser.id)
                      ? MdiIcons.accountRemoveOutline
                      : data.receivedFriendRequests.contains(currentUser.id)
                          ? MdiIcons.accountCheckOutline
                          : MdiIcons.accountPlusOutline
                  : data.membersUIDs.contains(currentUser.id)
                      ? MdiIcons.exitRun
                      : MdiIcons.accountMultiplePlus,
              size: 24.r,
            ),
          );
  }
}
