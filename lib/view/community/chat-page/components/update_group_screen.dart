import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/providers/groupe/message/group_chat_provider.dart';
import 'package:athlete_iq/resources/components/Button/CustomElevatedButton.dart';
import 'package:athlete_iq/view/community/chat-page/components/user_list_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/resources/components/CustomAppBar.dart';

class UpdateGroupScreen extends ConsumerWidget {
  const UpdateGroupScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupChatProvider(groupId));
    ref.read(groupPrivacyProvider(groupId));
    final isLoading = ref
        .watch(groupActionsProvider)
        .maybeWhen(orElse: () => false, loading: () => true);
    final user = ref.read(globalProvider.select((state) =>
        state.userState.maybeWhen(orElse: () => null, loaded: (user) => user)));

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Modifier le groupe',
        hasBackButton: true,
        backIcon: Icons.close,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: groupState.when(
        initial: () => const Center(child: Text('Initial state')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (groupDetails, messagesStream, _) =>
            buildGroupForm(context, ref, groupDetails, isLoading, user!.id),
        error: (message) => Center(child: Text(message)),
      ),
    );
  }

  Widget buildGroupForm(BuildContext context, WidgetRef ref, GroupModel group,
      bool isLoading, String userId) {
    final titleController = TextEditingController(text: group.groupName);
    final isPrivate = ref
        .watch(groupPrivacyProvider(groupId)); // Observer l'état privé/publique

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titre du groupe',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            SwitchListTile(
              title: const Text('Groupe privé'),
              value: isPrivate,
              onChanged: (bool value) {
                ref.read(groupPrivacyProvider(groupId).notifier).state = value;
              },
            ),
            if (isPrivate)
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 200), // Adjust as needed
                child: const UserListComponent(),
              ),
            CustomElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await updateGroup(context, ref, titleController.text,
                          group, isPrivate, [], userId);
                    },
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: Icons.edit,
              text: 'Modifier',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateGroup(
      BuildContext context,
      WidgetRef ref,
      String title,
      GroupModel group,
      bool isPrivate,
      List<String> members,
      String userId) async {
    final updatedGroup = group.copyWith(
        groupName: title,
        type: isPrivate ? 'private' : 'public',
        members: members);
    await ref
        .read(groupActionsProvider.notifier)
        .updateGroup(updatedGroup, userId);
  }
}
