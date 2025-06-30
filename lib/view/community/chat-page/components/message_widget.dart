import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/view/community/chat-page/components/swipe_to_widget.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.message,
    required this.groupId,
    required this.onSwipe,
    required this.isMe,
  });

  final MessageModel message;
  final String groupId;
  final Function() onSwipe;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return SwipeToWidget(
      onSwipe: onSwipe,
      message: message,
      isMe: isMe,
      groupId: groupId,
    );
  }
}
