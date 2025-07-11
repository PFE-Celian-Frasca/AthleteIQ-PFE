import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.color,
    required this.viewOnly,
  });

  final String videoUrl;
  final Color color;
  final bool viewOnly;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _showFullScreenVideo() {
    final chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(
            controller: chewieController,
          ),
        ),
      ),
    ).then((_) {
      chewieController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showFullScreenVideo,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : VideoPlayer(_videoPlayerController),
            if (!widget.viewOnly)
              Center(
                child: Icon(
                  Icons.play_circle_outline,
                  color: widget.color.withValues(alpha: 0.8),
                  size: 64,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
