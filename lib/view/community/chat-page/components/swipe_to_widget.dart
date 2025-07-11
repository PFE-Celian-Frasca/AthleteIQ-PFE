import 'package:athlete_iq/models/message/message_model.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:athlete_iq/view/community/chat-page/components/align_message_left_widget.dart';
import 'package:athlete_iq/view/community/chat-page/components/align_message_right_widget.dart';

class SwipeToWidget extends StatelessWidget {
  const SwipeToWidget({
    super.key,
    required this.onSwipe,
    required this.message,
    required this.groupId,
    required this.isMe,
  });

  final VoidCallback onSwipe;
  final MessageModel message;
  final String groupId;
  final bool isMe;

  void _handleSwipe(DragUpdateDetails details) {
    onSwipe();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: isMe ? null : _handleSwipe,
      onLeftSwipe: isMe ? _handleSwipe : null,
      child: isMe
          ? AlignMessageRightWidget(
              message: message,
              groupId: groupId,
            )
          : AlignMessageLeftWidget(
              message: message,
              groupId: groupId,
            ),
    );
  }
}
