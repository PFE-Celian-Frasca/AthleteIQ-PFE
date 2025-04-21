import 'dart:io';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/providers/groupe/message/group_chat_provider.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_provider.dart';
import 'package:athlete_iq/view/community/providers/image_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'components/message_tile.dart';

class ChatPage extends HookConsumerWidget {
  final String groupId;

  const ChatPage(this.groupId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageController = useTextEditingController();
    final scrollController = useScrollController();
    final ImagePicker imagePicker = ImagePicker();
    final imageFiles = ref.watch(imageListProvider);
    final currentUser = ref.watch(globalProvider.select((state) =>
        state.userState.maybeWhen(orElse: () => null, loaded: (user) => user)));
    final groupChatState = ref.watch(groupChatProvider(groupId));

    Future<void> pickImages() async {
      String tempText = messageController
          .text; // Sauvegarde du texte avant la sélection des images
      final List<XFile> selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        ref.read(imageListProvider.notifier).state = [
          ...ref.read(imageListProvider.notifier).state,
          ...selectedImages
        ];
      }
      messageController.text =
          tempText; // Restauration du texte après la sélection
    }

    void removeImage(int index) {
      ref.read(imageListProvider.notifier).state =
          List.from(ref.read(imageListProvider.notifier).state)
            ..removeAt(index);
    }

    void sendMessage() async {
      final textLength = messageController.text.length;
      final totalImageSize = imageFiles.isNotEmpty
          ? await Future.wait(
                  imageFiles.map((xFile) => File(xFile.path).length()))
              .then((sizes) => sizes.reduce((sum, length) => sum + length))
          : 0;
      const int maxSize = 10 * 1024 * 1024; // 10 MB

      if (textLength + totalImageSize > maxSize) {
        ref.read(notificationNotifierProvider.notifier).showToast(
            "Votre message est trop long. Veuillez réduire la taille.");
        return;
      }

      if (textLength > 0 || imageFiles.isNotEmpty) {
        final files = imageFiles.map((xFile) => File(xFile.path)).toList();
        await ref
            .read(groupChatProvider(groupId).notifier)
            .sendMessage(messageController.text, files, currentUser!.id);
        messageController.clear();
        ref.read(imageListProvider.notifier).state.clear();
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
      }
    }

    return groupChatState.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (groupDetails, messagesStream, isSending) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(groupDetails.groupName),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () =>
                  GoRouter.of(context).go('/groups/chat/$groupId/details'),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }
                  var messages = snapshot.data!;
                  return ListView.builder(
                    controller: scrollController,
                    reverse: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data![index];
                      return FutureBuilder<UserModel>(
                        future: ref
                            .read(userServiceProvider)
                            .getUserData(message.sender),
                        builder: (context, senderSnapshot) {
                          if (!senderSnapshot.hasData) {
                            return Container();
                          }
                          return MessageTile(
                            message: message.content,
                            sender: senderSnapshot.data!,
                            date: message.createdAt,
                            sentByMe: currentUser?.id == message.sender,
                            images: message.images,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            if (imageFiles.isNotEmpty)
              SizedBox(
                height: 50.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageFiles.length,
                  itemBuilder: (context, index) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                        child: Image.file(File(imageFiles[index].path)),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => removeImage(index),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration:
                          const InputDecoration(hintText: "Send a message..."),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_camera),
                    onPressed: pickImages,
                  ),
                  if (isSending)
                    const CircularProgressIndicator()
                  else
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: sendMessage,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      error: (message) => Center(child: Text('Error: $message')),
    );
  }
}
