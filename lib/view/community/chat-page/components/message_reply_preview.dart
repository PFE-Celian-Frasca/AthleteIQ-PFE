import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/models/message/message_reply_model.dart';
import 'package:athlete_iq/utils/global_methods.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'display_message_type.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({
    super.key,
    this.replyMessageModel,
    this.message,
    this.viewOnly = false,
  });

  final MessageReplyModel? replyMessageModel;
  final MessageModel? message;
  final bool viewOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = ref.watch(chatControllerProvider);
    final messageReplyModel = chatController.messageReplyModel;
    final type = messageReplyModel != null
        ? messageReplyModel.messageType
        : message!.messageType;
    final intrisitPadding = messageReplyModel != null
        ? const EdgeInsets.all(10)
        : const EdgeInsets.only(top: 5, right: 5, bottom: 5);

    final decorationColor = messageReplyModel != null
        ? Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.1)
        : Theme.of(context).primaryColorDark.withOpacity(0.2);
    return IntrinsicHeight(
      child: Container(
        padding: intrisitPadding,
        decoration: BoxDecoration(
          color: decorationColor,
          borderRadius: messageReplyModel != null
              ? BorderRadius.circular(20)
              : BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            buildNameAndMessage(type, messageReplyModel),
            messageReplyModel != null ? const Spacer() : const SizedBox(),
            messageReplyModel != null
                ? closeButton(ref, context)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  InkWell closeButton(WidgetRef ref, BuildContext context) {
    return InkWell(
      onTap: () {
        ref.read(chatControllerProvider.notifier).setMessageReplyModel(null);
      },
      child: Container(
          decoration: BoxDecoration(
            color:
                Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Theme.of(context).textTheme.titleLarge!.color!,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: const Icon(Icons.close)),
    );
  }

  Column buildNameAndMessage(
      MessageEnum type, MessageReplyModel? messageReplyModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle(messageReplyModel),
        const SizedBox(height: 5),
        messageReplyModel != null
            ? messageToShow(
                type: type,
                message: messageReplyModel.message,
              )
            : DisplayMessageType(
                message: message!.repliedMessage,
                type: message!.repliedMessageType,
                color: Colors.white,
                isReply: true,
                maxLines: 1,
                overFlow: TextOverflow.ellipsis,
                viewOnly: viewOnly,
              ),
      ],
    );
  }

  Widget getTitle(MessageReplyModel? messageReplyModel) {
    if (messageReplyModel != null) {
      bool isMe = messageReplyModel.isMe;
      return Text(
        isMe ? 'You' : messageReplyModel.senderName,
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      );
    } else {
      return Text(
        message!.repliedTo,
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      );
    }
  }
}
