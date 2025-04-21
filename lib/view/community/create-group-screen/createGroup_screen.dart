import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/resources/components/Button/CustomElevatedButton.dart';
import 'package:athlete_iq/resources/components/CustomAppBar.dart';
import 'package:athlete_iq/resources/components/InputField/CustomInputField.dart';
import 'package:athlete_iq/utils/visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class CreateGroupScreen extends HookConsumerWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picker = ImagePicker();
    final file = useState<File?>(null);
    String groupName = '';
    GroupType? groupType;
    final user = ref.read(globalProvider.select((state) =>
        state.userState.maybeWhen(orElse: () => null, loaded: (user) => user)));

    Future<void> pickImage() async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        file.value = File(image.path);
      }
    }

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
                        size: 60, color: Theme.of(context).colorScheme.tertiary)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            CustomInputField(
              context: context,
              onChanged: (value) => groupName = value,
              label: 'Nom du groupe',
              icon: Icons.group,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<GroupType>(
              style: Theme.of(context).textTheme.bodyLarge,
              value: groupType,
              onChanged: (newValue) => groupType = newValue,
              items: GroupType.values.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Type de groupe',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                prefixIcon: const Icon(Icons.visibility),
              ),
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              text: "Créer le groupe",
              onPressed: () async {
                if (groupName.isNotEmpty && groupType != null && user != null) {
                  final newGroup = GroupModel(
                    groupName: groupName.toLowerCase(),
                    type: groupType.toString().split('.').last,
                    admin: user.id,
                    recentMessage: '',
                    recentMessageSender: '',
                    recentMessageTime: DateTime.now(),
                  );
                  await ref
                      .read(groupActionsProvider.notifier)
                      .createGroup(newGroup, imageFile: file.value)
                      .then((_) => GoRouter.of(context).pop());
                }
              },
              icon: Icons.add,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
