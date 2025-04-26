import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/view/community/chat-page/components/video_player_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'audio_player_widget.dart';

class DisplayMessageType extends StatelessWidget {
  const DisplayMessageType({
    super.key,
    required this.message,
    required this.type,
    required this.color,
    required this.isReply,
    this.maxLines,
    this.overFlow,
    required this.viewOnly,
  });

  final String message;
  final MessageEnum type;
  final Color color;
  final bool isReply;
  final int? maxLines;
  final TextOverflow? overFlow;
  final bool viewOnly;

  @override
  Widget build(BuildContext context) {
    Widget messageToShow() {
      switch (type) {
        case MessageEnum.text:
          return Text(
            message,
            style: TextStyle(
              color: color,
              fontSize: 16.0,
            ),
            maxLines: maxLines,
            overflow: overFlow,
          );
        case MessageEnum.image:
          return isReply
              ? const Icon(Icons.image)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    width: 200,
                    height: 200,
                    imageUrl: message,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                  ),
                );
        case MessageEnum.video:
          return isReply
              ? const Icon(Icons.video_collection)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: VideoPlayerWidget(
                    videoUrl: message,
                    color: color,
                    viewOnly: viewOnly,
                  ),
                );
        case MessageEnum.audio:
          return isReply
              ? const Icon(Icons.audiotrack)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: AudioPlayerWidget(
                    audioUrl: message,
                    color: color,
                    viewOnly: viewOnly,
                  ),
                );
        default:
          return Text(
            message,
            style: TextStyle(
              color: color,
              fontSize: 16.0,
            ),
            maxLines: maxLines,
            overflow: overFlow,
          );
      }
    }

    return messageToShow();
  }
}
