import 'dart:io';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/global_methods.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:athlete_iq/view/community/chat-page/components/message_reply_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({
    super.key,
    required this.groupId,
  });

  final String groupId;

  @override
  BottomChatFieldState createState() => BottomChatFieldState();
}

class BottomChatFieldState extends ConsumerState<BottomChatField> {
  FlutterSoundRecord? _soundRecord;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  File? finalFileImage;
  String filePath = '';

  bool isRecording = false;
  bool isShowSendButton = false;
  bool isSendingAudio = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _soundRecord = FlutterSoundRecord();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _soundRecord?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void selectImage(bool fromCamera) async {
    finalFileImage = await pickImage(
      fromCamera: fromCamera,
      onFail: (String message) {
        showSnackBar(context, message);
      },
    );
    await cropImage(finalFileImage?.path);
    popContext();
  }

  void selectVideo() async {
    final File? fileVideo = await pickVideo(
      onFail: (String message) {
        showSnackBar(context, message);
      },
    );
    popContext();
    if (fileVideo != null) {
      filePath = fileVideo.path;
      sendFileMessage(
        messageType: MessageEnum.video,
      );
    }
  }

  void popContext() {
    Navigator.pop(context);
  }

  Future<void> cropImage(String? croppedFilePath) async {
    if (croppedFilePath != null) {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: croppedFilePath,
        maxHeight: 800.h.toInt(),
        maxWidth: 800.w.toInt(),
        compressQuality: 90,
      );
      if (croppedFile != null) {
        filePath = croppedFile.path;
        sendFileMessage(
          messageType: MessageEnum.image,
        );
      }
    }
  }

  void sendFileMessage({
    required MessageEnum messageType,
  }) async {
    final userId = ref.read(authRepositoryProvider).currentUser!.uid;
    final currentUser = await ref.read(userRepositoryProvider).getUserData(userId);
    if (!mounted) return; // Vérification si le widget est monté
    ref.read(chatControllerProvider.notifier).sendFileMessage(
          sender: currentUser,
          file: File(filePath),
          messageType: messageType,
          groupId: widget.groupId,
          onSuccess: () {
            _textEditingController.clear();
            _focusNode.unfocus();
            setState(() {
              isSendingAudio = false;
            });
          },
          onError: (error) {
            setState(() {
              isSendingAudio = false;
            });
            showSnackBar(context, error);
          },
        );
  }

  void sendTextMessage() async {
    if (_textEditingController.text.trim().isEmpty) {
      return; // Ne pas envoyer de message vide
    }

    final userId = ref.read(authRepositoryProvider).currentUser!.uid;
    final currentUser = await ref.read(userRepositoryProvider).getUserData(userId);
    if (!mounted) return; // Vérification si le widget est monté
    ref.read(chatControllerProvider.notifier).sendTextMessage(
          sender: currentUser,
          message: _textEditingController.text.trim(),
          messageType: MessageEnum.text,
          groupId: widget.groupId,
          onSuccess: () {
            _textEditingController.clear();
            _focusNode.unfocus();
          },
          onError: (error) {
            showSnackBar(context, error);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return buildBottomChatField();
  }

  Widget buildBottomChatField() {
    return Consumer(
      builder: (context, ref, child) {
        final chatState = ref.watch(chatControllerProvider);
        final messageReply = chatState.messageReplyModel;
        final isMessageReply = messageReply != null;
        final isButtonLoading = chatState.isButtonLoading;

        return Column(
          children: [
            if (isMessageReply)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.h),
                child: MessageReplyPreview(replyMessageModel: messageReply),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Container(
                padding: EdgeInsets.all(8.0.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2.h),
                      blurRadius: 6.r,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: isSendingAudio
                          ? null
                          : () {
                              showModalBottomSheet<void>(
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0.w),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.camera_alt),
                                            title: const Text('Camera'),
                                            onTap: () {
                                              selectImage(true);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.image),
                                            title: const Text('Gallery'),
                                            onTap: () {
                                              selectImage(false);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.video_library),
                                            title: const Text('Video'),
                                            onTap: selectVideo,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                      icon: Icon(Icons.attachment, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _textEditingController,
                        focusNode: _focusNode,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Chat...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
                        ),
                        onChanged: (value) {
                          setState(() {
                            isShowSendButton = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: isShowSendButton && !isButtonLoading ? sendTextMessage : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(12.0.w),
                        child: isButtonLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Icon(
                                isShowSendButton ? Icons.send : Icons.mic,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
