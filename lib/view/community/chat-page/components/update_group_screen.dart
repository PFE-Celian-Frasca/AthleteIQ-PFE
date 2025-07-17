import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/providers/groupe/group_details/group_details_provider.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/resources/components/Button/custom_elevated_button.dart';
import 'package:athlete_iq/resources/components/ConfirmationDialog/custom_confirmation_dialog.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/view/community/chat-page/components/generic_list_component.dart';
import 'package:athlete_iq/view/community/search-screen/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';

import 'package:athlete_iq/view/community/chat-page/components/custom_animated_toggle.dart';

class UpdateGroupScreen extends HookConsumerWidget {
  const UpdateGroupScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupDetailsAsyncValue = ref.watch(groupDetailsProvider(groupId));
    final isPrivate = useState<bool>(false); // Use useState to track privacy state
    final isLoading = ref.watch(groupActionsProvider).maybeWhen(
          orElse: () => false,
          loading: () => true,
        );

    final userId = ref.watch(authRepositoryProvider).currentUser?.uid ?? "";
    final currentUserAsync = ref.watch(currentUserProvider(userId));

    return currentUserAsync.when(
      data: (currentUser) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Modifier le groupe',
            hasBackButton: true,
            backIcon: Icons.close,
            onBackButtonPressed: () => Navigator.of(context).pop(),
          ),
          body: groupDetailsAsyncValue.when(
            data: (group) {
              isPrivate.value =
                  group.isPrivate; // Initialize isPrivate with group's privacy setting
              return buildGroupForm(
                context,
                ref,
                group,
                isLoading,
                currentUser!.id,
                isPrivate,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Erreur: $error')),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erreur: $error')),
    );
  }

  Widget buildGroupForm(BuildContext context, WidgetRef ref, GroupModel group, bool isLoading,
      String currentUserId, ValueNotifier<bool> isPrivate) {
    final titleController = TextEditingController(text: group.groupName);
    final selectedUserIds = useState<List<String>>(group.membersUIDs);
    final selectedUsers = useState<Map<String, UserModel>>({});

    useEffect(() {
      Future<void> loadSelectedUsers() async {
        final users = await Future.wait(selectedUserIds.value.map((userId) async {
          final user = await ref.read(userServiceProvider).getUserData(userId);
          return MapEntry(userId, user);
        }));
        selectedUsers.value = Map.fromEntries(users);
      }

      loadSelectedUsers();
      return;
    }, [selectedUserIds.value]);

    void toggleUser(UserModel user) {
      final userId = user.id;
      if (selectedUserIds.value.contains(userId)) {
        selectedUserIds.value = List.from(selectedUserIds.value)..remove(userId);
        selectedUsers.value.remove(userId);
      } else {
        selectedUserIds.value = List.from(selectedUserIds.value)..add(userId);
        selectedUsers.value[userId] = user;
        selectedUsers.value = Map.from(selectedUsers.value);
      }
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FocusTraversalGroup(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Groupe privé', style: Theme.of(context).textTheme.bodySmall),
                  CustomAnimatedToggle(
                    value: isPrivate.value,
                    onChanged: (bool value) {
                      isPrivate.value = value;
                    },
                  ),
                ],
              ),
            ),
            if (isPrivate.value)
              Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final users = ref.watch(userSearchProvider).filteredUsers;
                        return GenericListComponent<UserModel>(
                          onItemSelected: toggleUser,
                          selectedIds: selectedUserIds.value,
                          excludeId: currentUserId,
                          items: users.where((user) => user.id != currentUserId).toList(),
                          buildItem: (context, user) => Text(user.pseudo),
                          icon: const Icon(Icons.person),
                          idExtractor: (user) => user.id,
                        );
                      },
                    ),
                  ),
                ],
              ),
            CustomElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await updateGroup(context, ref, titleController.text, group, isPrivate.value,
                          selectedUserIds.value, currentUserId);
                    },
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: Icons.edit,
              text: 'Modifier',
            ),
            SizedBox(height: 20.h),
            CustomElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      showDialog<void>(
                          context: context,
                          builder: (context) => CustomConfirmationDialog(
                                title: 'Supprimer le groupe',
                                content: 'Êtes-vous sûr de vouloir supprimer ce groupe?',
                                backgroundColor: Theme.of(context).colorScheme.error,
                                onConfirm: () async {
                                  await ref
                                      .read(groupActionsProvider.notifier)
                                      .deleteGroup(group.groupId);
                                  if (context.mounted) {
                                    GoRouter.of(context).go('/groups');
                                  }
                                },
                                confirmText: 'Supprimer',
                                onCancel: () {
                                  Navigator.of(context).pop();
                                },
                              ));
                    },
              backgroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete,
              text: 'Supprimer le groupe',
            )
          ],
          ),
        ),
      ),
    );
  }

  Future<void> updateGroup(BuildContext context, WidgetRef ref, String title, GroupModel group,
      bool isPrivate, List<String> selectedUserIds, String userId) async {
    final updatedGroup = group.copyWith(
      groupName: title,
      isPrivate: isPrivate,
      membersUIDs: selectedUserIds,
    );
    await ref.read(groupActionsProvider.notifier).updateGroup(updatedGroup, userId);
  }
}
