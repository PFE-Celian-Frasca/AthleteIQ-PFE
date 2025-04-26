import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/utils/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/widgets/stacked_reactions.dart';
import 'package:intl/intl.dart';

import 'display_message_type.dart';
import 'message_reply_preview.dart';

class AlignMessageLeftWidget extends StatelessWidget {
  const AlignMessageLeftWidget({
    super.key,
    required this.message,
    this.viewOnly = false,
  });

  final MessageModel message;
  final bool viewOnly;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(message.timeSent);
    final isReplying = message.repliedTo.isNotEmpty;
    final messageReactions =
        message.reactions.map((e) => e.split('=')[1]).toList();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final padding = message.reactions.isNotEmpty
        ? const EdgeInsets.only(right: 20.0, bottom: 25.0)
        : const EdgeInsets.only(bottom: 0.0);

    final cardColor = isDarkMode ? Colors.grey[800] : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 5, top: 10), // Adjust top padding to lower the image
              child: Column(
                children: [
                  const SizedBox(
                      height: 20), // Add an empty space to push the image down
                  userImageWidget(
                    imageUrl: message.senderImage,
                    radius: 20,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: padding,
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.black45,
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
                          ? const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0)
                          : const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isReplying) ...[
                              MessageReplyPreview(
                                message: message,
                                viewOnly: viewOnly,
                              )
                            ],
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
                                  fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 50,
                  child: StackedReactions(
                    reactions: messageReactions,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
