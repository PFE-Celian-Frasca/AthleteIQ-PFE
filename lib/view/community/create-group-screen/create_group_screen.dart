import 'dart:io';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/resources/components/Button/custom_elevated_button.dart';
import 'package:athlete_iq/resources/components/ChoiceChip/custom_choice_chip.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/resources/components/InputField/custom_input_field.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/view/community/chat-page/components/generic_list_component.dart';
import 'package:athlete_iq/view/community/search-screen/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class CreateGroupScreen extends HookConsumerWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picker = ImagePicker();
    final file = useState<File?>(null);
    final isValid = useState<bool>(false);
    final groupNameController = useTextEditingController();
    final groupType = useState<GroupType>(GroupType.private);
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid ?? "";
    final currentUserAsync = ref.watch(currentUserProvider(userId));
    final selectedUserIds = useState<List<String>>([]);
    final selectedUsers = useState<Map<String, UserModel>>({});
    final isCreatingGroup = useState<bool>(false);

    useEffect(() {
      isValid.value = groupNameController.text.isNotEmpty &&
          (groupType.value != GroupType.private ||
              selectedUserIds.value.isNotEmpty);
      return null;
    }, [groupNameController.text, groupType.value, selectedUserIds.value]);

    Future<void> pickImage() async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        file.value = File(image.path);
      }
    }

    void toggleUser(UserModel user) {
      final userId = user.id;
      if (selectedUserIds.value.contains(userId)) {
        selectedUserIds.value = List.from(selectedUserIds.value)
          ..remove(userId);
        selectedUsers.value.remove(userId);
      } else {
        selectedUserIds.value = List.from(selectedUserIds.value)..add(userId);
        selectedUsers.value[userId] = user;
        selectedUsers.value = Map.from(selectedUsers.value);
      }
    }

    return currentUserAsync.when(
      data: (currentUser) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Créer un groupe',
            hasBackButton: true,
            backIcon: Icons.close,
            onBackButtonPressed: () => Navigator.of(context).pop(),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    backgroundImage:
                        file.value != null ? FileImage(file.value!) : null,
                    child: file.value == null
                        ? Icon(Icons.camera_alt,
                            size: 60,
                            color: Theme.of(context).colorScheme.tertiary)
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                CustomInputField(
                  context: context,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.words,
                  controller: groupNameController,
                  label: 'Nom du groupe',
                  icon: Icons.group,
                ),
                const SizedBox(height: 24),
                CustomChoiceChipSelector<GroupType>(
                  title: 'Type de groupe',
                  options: const {
                    GroupType.public: 'Public',
                    GroupType.private: 'Privé',
                  },
                  selectedValue: groupType.value,
                  onSelected: (GroupType value) {
                    groupType.value = value;
                  },
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                const SizedBox(height: 24),
                if (groupType.value == GroupType.private)
                  Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final users =
                                ref.watch(userSearchProvider).filteredUsers;
                            return GenericListComponent<UserModel>(
                              onItemSelected: toggleUser,
                              selectedIds: selectedUserIds.value,
                              excludeId: currentUser!.id,
                              items: users,
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
                  text:
                      isCreatingGroup.value ? "Création..." : "Créer le groupe",
                  onPressed: isCreatingGroup.value || !isValid.value
                      ? null
                      : () async {
                          if (groupNameController.text.isNotEmpty &&
                              currentUser != null) {
                            isCreatingGroup.value = true;
                            final newGroup = GroupModel(
                              creatorUID: currentUser.id,
                              groupName: groupNameController.text.toLowerCase(),
                              groupDescription: '',
                              groupImage: '',
                              groupId: '',
                              lastMessage: '',
                              senderUID: '',
                              messageType: MessageEnum.text,
                              messageId: '',
                              timeSent: DateTime.now(),
                              createdAt: DateTime.now(),
                              isPrivate: groupType.value == GroupType.private,
                              editSettings: true,
                              membersUIDs: [
                                currentUser.id,
                                ...selectedUserIds.value
                              ],
                              adminsUIDs: [currentUser.id],
                            );
                            await ref
                                .read(groupActionsProvider.notifier)
                                .createGroup(newGroup, imageFile: file.value)
                                .then((_) {
                              GoRouter.of(context).pop();
                              ref
                                  .read(internalNotificationProvider)
                                  .showToast('Groupe créé avec succès.');
                            }).whenComplete(() {
                              isCreatingGroup.value = false;
                            });
                          }
                        },
                  icon: isCreatingGroup.value ? null : Icons.add,
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
}
