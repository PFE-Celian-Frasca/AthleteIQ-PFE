import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:athlete_iq/view/community/chat-page/components/display_message_type.dart';
import 'package:athlete_iq/view/community/chat-page/components/message_reply_preview.dart';

class AlignMessageRightWidget extends ConsumerWidget {
  const AlignMessageRightWidget({
    super.key,
    required this.message,
    required this.groupId,
    this.viewOnly = false,
  });

  final MessageModel message;
  final String groupId;
  final bool viewOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = DateFormat('HH:mm').format(message.timeSent);
    final isReplying = message.repliedTo.isNotEmpty;
    final groupedReactions = _groupReactions(message.reactions);
    final padding = message.reactions.isNotEmpty
        ? EdgeInsets.only(left: 20.w, bottom: 25.h)
        : EdgeInsets.only(bottom: 0.h);

    bool messageSeen() {
      final uid = ref.read(authRepositoryProvider).currentUser!.uid;
      final List<String> isSeenByList = List.from(message.isSeenBy);
      if (isSeenByList.contains(uid)) {
        isSeenByList.remove(uid);
      }
      return isSeenByList.isNotEmpty;
    }

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.7.sw,
        ),
        child: Stack(
          children: [
            Padding(
              padding: padding,
              child: message.messageType == MessageEnum.image
                  ? _buildImageMessage(context, time, messageSeen())
                  : Card(
                      elevation: 5,
                      shadowColor: Colors.black.withValues(alpha: 0.15),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: message.messageType == MessageEnum.text
                            ? EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 10.h)
                            : EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isReplying)
                              MessageReplyPreview(
                                message: message,
                                viewOnly: viewOnly,
                              ),
                            DisplayMessageType(
                              message: message.message,
                              type: message.messageType,
                              color: Colors.white,
                              isReply: false,
                              viewOnly: viewOnly,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Icon(
                                  messageSeen() ? Icons.done_all : Icons.done,
                                  color: messageSeen() ? Colors.white : Colors.grey,
                                  size: 15.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 15.h,
              right: 10.w,
              child: _buildReactions(groupedReactions, context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context, String time, bool messageSeen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: DisplayMessageType(
              message: message.message,
              type: message.messageType,
              color: Colors.transparent,
              isReply: false,
              viewOnly: viewOnly,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10.sp,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Icon(
              messageSeen ? Icons.done_all : Icons.done,
              color: messageSeen ? Colors.white : Colors.grey,
              size: 15.sp,
            ),
          ],
        ),
      ],
    );
  }

  Map<String, int> _groupReactions(List<String> reactions) {
    final Map<String, int> groupedReactions = {};
    for (final reaction in reactions) {
      final emoji = reaction.split('=')[1];
      if (groupedReactions.containsKey(emoji)) {
        groupedReactions[emoji] = groupedReactions[emoji]! + 1;
      } else {
        groupedReactions[emoji] = 1;
      }
    }
    return groupedReactions;
  }

  Widget _buildReactions(Map<String, int> groupedReactions, BuildContext context, WidgetRef ref) {
    final senderUID = ref.read(authRepositoryProvider).currentUser!.uid;
    return Row(
      children: groupedReactions.entries.map((entry) {
        final isUserReaction =
            message.reactions.any((reaction) => reaction == '$senderUID=${entry.key}');
        return GestureDetector(
          onTap: () {
            if (isUserReaction) {
              ref.read(chatControllerProvider.notifier).sendReactionToMessage(
                    senderUID: senderUID,
                    groupId: groupId,
                    messageId: message.messageId,
                    reaction: '',
                  );
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(fontSize: 16.sp),
                ),
                if (entry.value > 1)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${entry.value}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
