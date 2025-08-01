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
import 'package:intl/intl.dart';

import 'package:athlete_iq/view/community/chat-page/components/align_message_left_widget.dart';
import 'package:athlete_iq/view/community/chat-page/components/align_message_right_widget.dart';

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
          // Sort messages by timeSent in ascending order for display purposes
          messagesList.sort((a, b) => b.timeSent.compareTo(a.timeSent));

          final Map<String, List<MessageModel>> groupedMessages = {};
          for (final message in messagesList) {
            final date = DateFormat('dd MMM yyyy', 'fr_FR').format(message.timeSent);
            if (groupedMessages.containsKey(date)) {
              groupedMessages[date]!.add(message);
            } else {
              groupedMessages[date] = [message];
            }
          }

          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: _scrollController,
            itemCount: groupedMessages.length,
            reverse: true,
            itemBuilder: (context, index) {
              final date = groupedMessages.keys.elementAt(index);
              final messages = groupedMessages[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  ...messages.reversed.map((message) {
                    Future.delayed(Duration.zero, () {
                      ref.read(chatControllerProvider.notifier).setMessageStatus(
                            currentUserId: uid,
                            groupId: widget.groupId,
                            messageId: message.messageId,
                            isSeenByList: message.isSeenBy,
                          );
                    });
                    final isMe = message.senderUID == uid;
                    final bool deletedByCurrentUser = message.deletedBy.contains(uid);
                    return deletedByCurrentUser
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: GestureDetector(
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
                  }),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
