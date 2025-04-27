import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/view/community/chat-page/components/video_player_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'audio_player_widget.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';

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
              fontSize: 16.sp,
            ),
            maxLines: maxLines,
            overflow: overFlow,
          );
        case MessageEnum.image:
          return isReply
              ? const Icon(Icons.image)
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullScreenImageView(imageUrl: message),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: CachedNetworkImage(
                      width: 200.w,
                      height: 200.h,
                      imageUrl: message,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 200.w,
                        height: 200.h,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 200.w,
                        height: 200.h,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
        case MessageEnum.video:
          return isReply
              ? const Icon(Icons.video_collection)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
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
                  borderRadius: BorderRadius.circular(15.r),
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
              fontSize: 16.sp,
            ),
            maxLines: maxLines,
            overflow: overFlow,
          );
      }
    }

    return messageToShow();
  }
}

class FullScreenImageView extends ConsumerStatefulWidget {
  final String imageUrl;

  const FullScreenImageView({super.key, required this.imageUrl});

  @override
  FullScreenImageViewState createState() => FullScreenImageViewState();
}

class FullScreenImageViewState extends ConsumerState<FullScreenImageView> {
  bool _isDownloading = false;
  double _progress = 0.0;

  Future<void> _downloadImage() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    try {
      final response = await Dio().get(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );
      final Uint8List bytes = response.data;
      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));

      if (result['isSuccess']) {
        ref
            .read(internalNotificationProvider)
            .showToast('Image téléchargée avec succès!');
      } else {
        ref
            .read(internalNotificationProvider)
            .showErrorToast('Erreur lors du téléchargement de l\'image.');
      }
    } catch (e) {
      ref.read(internalNotificationProvider).showErrorToast('Erreur: $e');
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasBackButton: true,
        actions: [
          _isDownloading
              ? Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _progress,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      Text(
                        '${(_progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.download, size: 24.sp),
                  onPressed: _downloadImage,
                ),
        ],
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget.imageUrl),
        ),
      ),
    );
  }
}
