import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/providers/groupe/group_details/group_details_provider.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/utils/string_capitalize.dart';
import 'package:athlete_iq/view/community/chat-page/components/update_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:athlete_iq/models/group/group_model.dart';

class GroupInfo extends ConsumerWidget {
  final String groupId;

  const GroupInfo(this.groupId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid ?? "";
    final currentUserAsync = ref.watch(currentUserProvider(userId));
    final groupDetailsAsyncValue = ref.watch(groupDetailsProvider(groupId));

    return groupDetailsAsyncValue.when(
      data: (group) {
        return currentUserAsync.when(
          data: (currentUser) {
            return Scaffold(
              appBar: CustomAppBar(
                title: "Information du groupe",
                hasBackButton: true,
                backIcon: Icons.arrow_back,
                onBackButtonPressed: () => Navigator.of(context).pop(),
                actions: [
                  group.adminsUIDs.contains(currentUser?.id)
                      ? IconButton(
                          icon: const Icon(UniconsLine.edit),
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => UpdateGroupScreen(groupId: groupId))),
                        )
                      : IconButton(
                          icon: const Icon(UniconsLine.exit),
                          onPressed: () =>
                              _confirmExitGroupDialog(context, ref, groupId, currentUser!),
                        ),
                ],
              ),
              body: _groupDetails(group, context, ref),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Erreur: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erreur: $error')),
    );
  }

  Widget _groupDetails(GroupModel group, BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                group.groupImage.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(group.groupImage),
                        radius: 25.r,
                      )
                    : CircleAvatar(
                        radius: 25.r,
                        child: Text(group.groupName.initials()),
                      ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(group.groupName.capitalize(),
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _memberList(group, ref, context),
        ],
      ),
    );
  }

  Widget _memberList(GroupModel group, WidgetRef ref, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text("${group.membersUIDs.length} Membres",
              style: Theme.of(context).textTheme.titleSmall),
        ),
        ListView.builder(
          itemCount: group.membersUIDs.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final member = group.membersUIDs[index];
            return FutureBuilder(
                future: ref.read(userServiceProvider).getUserData(member),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    final UserModel user = snapshot.data as UserModel;
                    return ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
                      title: Text(user.pseudo),
                      subtitle: group.adminsUIDs.contains(member)
                          ? Text("Administrateur", style: Theme.of(context).textTheme.labelSmall)
                          : Text("Membre", style: Theme.of(context).textTheme.labelSmall),
                    );
                  }
                });
          },
        ),
      ],
    );
  }

  void _confirmExitGroupDialog(
      BuildContext context, WidgetRef ref, String groupId, UserModel currentUser) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quitter le groupe"),
        content: const Text("Êtes-vous sûr de vouloir quitter ce groupe ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(groupActionsProvider.notifier)
                  .removeMemberFromGroup(groupId, currentUser.id);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Quitter", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
