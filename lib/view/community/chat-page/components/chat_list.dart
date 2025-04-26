import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/models/message/message_reply_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:athlete_iq/view/community/chat-page/components/swipe_to_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_reactions/flutter_chat_reactions.dart';
import 'package:flutter_chat_reactions/utilities/hero_dialog_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'align_message_left_widget.dart';
import 'align_message_right_widget.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({
    super.key,
    required this.groupId,
  });

  final String groupId;

  @override
  ChatListState createState() => ChatListState();
}

class ChatListState extends ConsumerState<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onContextMenuClicked({
    required String item,
    required MessageModel message,
  }) {
    switch (item) {
      case 'Reply':
        final messageReply = MessageReplyModel(
          message: message.message,
          senderUID: message.senderUID,
          senderName: message.senderName,
          senderImage: message.senderImage,
          messageType: message.messageType,
          isMe: message.senderUID ==
              ref.read(authRepositoryProvider).currentUser!.uid,
        );
        ref
            .read(chatControllerProvider.notifier)
            .setMessageReplyModel(messageReply);
        break;
      case 'Copy':
        Clipboard.setData(ClipboardData(text: message.message));
        ref.read(internalNotificationProvider).showToast('Message copié');
        break;
      case 'Delete':
        final currentUserId = ref.read(authRepositoryProvider).currentUser!.uid;
        showDeleteBottomSheet(
          message: message,
          currentUserId: currentUserId,
          isSenderOrAdmin: message.senderUID == currentUserId,
        );
        break;
    }
  }

  void showDeleteBottomSheet({
    required MessageModel message,
    required String currentUserId,
    required bool isSenderOrAdmin,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final chatProvider = ref.read(chatControllerProvider.notifier);
            final chatState = ref.watch(chatControllerProvider);
            return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 20.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (chatState.isLoading) const LinearProgressIndicator(),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Supprimer pour moi'),
                      onTap: chatState.isLoading
                          ? null
                          : () async {
                              await chatProvider
                                  .deleteMessage(
                                currentUserId: currentUserId,
                                groupId: widget.groupId,
                                messageId: message.messageId,
                                messageType: message.messageType.name,
                                deleteForEveryone: false,
                              )
                                  .whenComplete(() {
                                Navigator.pop(context);
                              });
                            },
                    ),
                    isSenderOrAdmin
                        ? ListTile(
                            leading: const Icon(Icons.delete_forever),
                            title: const Text('Supprimer pour tout le monde'),
                            onTap: chatState.isLoading
                                ? null
                                : () async {
                                    await chatProvider
                                        .deleteMessage(
                                      currentUserId: currentUserId,
                                      groupId: widget.groupId,
                                      messageId: message.messageId,
                                      messageType: message.messageType.name,
                                      deleteForEveryone: true,
                                    )
                                        .whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                  },
                          )
                        : const SizedBox.shrink(),
                    ListTile(
                      leading: const Icon(Icons.cancel),
                      title: const Text('Annuler'),
                      onTap: chatState.isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void sendReactionToMessage({
    required String reaction,
    required String messageId,
  }) {
    final senderUID = ref.read(authRepositoryProvider).currentUser!.uid;
    ref.read(chatControllerProvider.notifier).sendReactionToMessage(
          senderUID: senderUID,
          groupId: widget.groupId,
          messageId: messageId,
          reaction: reaction,
        );
  }

  void showEmojiContainer({required String messageId}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 300.h,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            Navigator.pop(context);
            sendReactionToMessage(
              reaction: emoji.emoji,
              messageId: messageId,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return StreamBuilder<List<MessageModel>>(
      stream: ref.read(chatControllerProvider.notifier).getMessagesStream(
            groupId: widget.groupId,
          ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Une erreur est survenue'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Commencez une conversation',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.normal,
                letterSpacing: 1.2,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          final messagesList = snapshot.data!;
          messagesList.sort((a, b) => b.timeSent.compareTo(a.timeSent));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            }
          });
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            controller: _scrollController,
            itemCount: messagesList.length,
            itemBuilder: (context, index) {
              final message = messagesList[index];
              Future.delayed(Duration.zero, () {
                ref.read(chatControllerProvider.notifier).setMessageStatus(
                      currentUserId: uid,
                      groupId: widget.groupId,
                      messageId: message.messageId,
                      isSeenByList: message.isSeenBy,
                    );
              });
              final isMe = message.senderUID == uid;
              bool deletedByCurrentUser = message.deletedBy.contains(uid);
              return deletedByCurrentUser
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: GestureDetector(
                        onLongPress: () async {
                          Navigator.of(context).push(
                            HeroDialogRoute(builder: (context) {
                              return ReactionsDialogWidget(
                                id: message.messageId,
                                messageWidget: isMe
                                    ? AlignMessageRightWidget(
                                        message: message,
                                        groupId: widget.groupId,
                                        viewOnly: true,
                                      )
                                    : AlignMessageLeftWidget(
                                        message: message,
                                        groupId: widget.groupId,
                                        viewOnly: true,
                                      ),
                                onReactionTap: (reaction) {
                                  if (reaction == '➕') {
                                    showEmojiContainer(
                                      messageId: message.messageId,
                                    );
                                  } else {
                                    sendReactionToMessage(
                                      reaction: reaction,
                                      messageId: message.messageId,
                                    );
                                  }
                                },
                                onContextMenuTap: (item) {
                                  onContextMenuClicked(
                                    item: item.label,
                                    message: message,
                                  );
                                },
                                widgetAlignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                              );
                            }),
                          );
                        },
                        child: Hero(
                          tag: message.messageId,
                          child: SwipeToWidget(
                            onSwipe: () {
                              final messageReply = MessageReplyModel(
                                message: message.message,
                                senderUID: message.senderUID,
                                senderName: message.senderName,
                                senderImage: message.senderImage,
                                messageType: message.messageType,
                                isMe: isMe,
                              );
                              ref
                                  .read(chatControllerProvider.notifier)
                                  .setMessageReplyModel(messageReply);
                            },
                            message: message,
                            isMe: isMe,
                            groupId: widget.groupId,
                          ),
                        ),
                      ),
                    );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
