import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/groupe/message/group_chat_provider.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/view/community/chat-page/components/update_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';

String _getInitials(String groupName) {
  return groupName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join();
}

class GroupInfo extends ConsumerWidget {
  final String groupId;

  const GroupInfo(this.groupId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(globalProvider.select((state) =>
        state.userState.maybeWhen(orElse: () => null, loaded: (user) => user)));
    final groupState = ref.watch(groupChatProvider(groupId));

    final group = groupState.maybeWhen(
      loaded: (groupDetail, messagesStream, _) => groupDetail,
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Information du groupe"),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        actions: [
          if (group != null)
            currentUser?.id == group.admin
                ? IconButton(
                    icon: const Icon(UniconsLine.edit),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) =>
                                UpdateGroupScreen(groupId: groupId))),
                  )
                : IconButton(
                    icon: const Icon(UniconsLine.exit),
                    onPressed: () => _confirmExitGroupDialog(
                        context, ref, groupId, currentUser!),
                  ),
        ],
      ),
      body: group != null
          ? _groupDetails(group, context, ref)
          : const Center(child: CircularProgressIndicator()),
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
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                group.groupIcon != null && group.groupIcon!.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(group.groupIcon!),
                        radius: 25.r,
                      )
                    : CircleAvatar(
                        radius: 25.r,
                        child: Text(_getInitials(group.groupName)),
                      ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Groupe: ${group.groupName}",
                          style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 5.h),
                      FutureBuilder(
                          future: ref
                              .read(userServiceProvider)
                              .getUserData(group.admin),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              UserModel user = snapshot.data as UserModel;
                              return Text("Administrateur: ${user.pseudo}",
                                  style: Theme.of(context).textTheme.titleMedium);
                            }
                          }),
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
          child: Text("${group.members.length} Membres",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        ListView.builder(
          itemCount: group.members.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final member = group.members[index];
            return FutureBuilder(
                future: ref.read(userServiceProvider).getUserData(member),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    UserModel user = snapshot.data as UserModel;
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.image)),
                      title: Text(user.pseudo),
                      subtitle: Text(
                          "Role: ${group.admin == user.id ? "Admin" : "Membre"}"),
                    );
                  }
                });
          },
        ),
      ],
    );
  }

  void _confirmExitGroupDialog(BuildContext context, WidgetRef ref,
      String groupId, UserModel currentUser) {
    showDialog(
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
              /*await ref
                  .read(groupProvider.notifier)
                  .removeMemberFromGroup(groupId, currentUser!.id);*/
              Navigator.pop(context);
            },
            child: const Text("Quitter", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
