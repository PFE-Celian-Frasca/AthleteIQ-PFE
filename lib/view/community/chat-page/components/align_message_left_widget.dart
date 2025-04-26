import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/utils/global_methods.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'display_message_type.dart';
import 'message_reply_preview.dart';

class AlignMessageLeftWidget extends ConsumerWidget {
  const AlignMessageLeftWidget({
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final padding = message.reactions.isNotEmpty
        ? EdgeInsets.only(right: 20.w, bottom: 25.h)
        : EdgeInsets.only(bottom: 0.h);

    final cardColor = isDarkMode ? Colors.grey[800] : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.7.sw,
          minWidth: 0.3.sw,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 5.w,
                top: 10.h,
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  userImageWidget(
                    imageUrl: message.senderImage,
                    radius: 20.r,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: padding,
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.15),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      color: cardColor,
                      child: Padding(
                        padding: message.messageType == MessageEnum.text
                            ? EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 10.h)
                            : EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isReplying)
                              MessageReplyPreview(
                                message: message,
                                viewOnly: viewOnly,
                              ),
                            DisplayMessageType(
                              message: message.message,
                              type: message.messageType,
                              color: textColor,
                              isReply: false,
                              viewOnly: viewOnly,
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white60
                                    : Colors.grey.shade600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15.h,
                    left: 45.w,
                    child: _buildReactions(groupedReactions, context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _groupReactions(List<String> reactions) {
    final Map<String, int> groupedReactions = {};
    for (var reaction in reactions) {
      final emoji = reaction.split('=')[1];
      if (groupedReactions.containsKey(emoji)) {
        groupedReactions[emoji] = groupedReactions[emoji]! + 1;
      } else {
        groupedReactions[emoji] = 1;
      }
    }
    return groupedReactions;
  }

  Widget _buildReactions(
      Map<String, int> groupedReactions, BuildContext context, WidgetRef ref) {
    final senderUID = ref.read(authRepositoryProvider).currentUser!.uid;
    return Row(
      children: groupedReactions.entries.map((entry) {
        final isUserReaction = message.reactions
            .any((reaction) => reaction == '$senderUID=${entry.key}');
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
