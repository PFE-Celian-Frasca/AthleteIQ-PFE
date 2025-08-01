import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/view/community/chat-page/components/display_message_type.dart';
import 'package:athlete_iq/view/community/chat-page/components/video_player_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

class MockVideoPlayerPlatform extends VideoPlayerPlatform with MockPlatformInterfaceMixin {
  @override
  Future<void> init() async {}

  @override
  Future<void> dispose(int textureId) async {}

  @override
  Future<int> create(DataSource dataSource) async => 1;

  @override
  Future<void> play(int textureId) async {}

  @override
  Future<void> pause(int textureId) async {}

  @override
  Future<void> setLooping(int textureId, bool looping) async {}

  @override
  Future<void> setVolume(int textureId, double volume) async {}

  @override
  Future<void> seekTo(int textureId, Duration position) async {}

  @override
  Future<Duration> getPosition(int textureId) async => Duration.zero;

  @override
  Future<void> setPlaybackSpeed(int textureId, double speed) async {}

  @override
  Stream<VideoEvent> videoEventsFor(int textureId) => const Stream.empty();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    VideoPlayerPlatform.instance = MockVideoPlayerPlatform();
  });

  group('DisplayMessageType', () {
    testWidgets('renders image in reply mode correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DisplayMessageType(
              message: 'https://example.com/image.jpg',
              type: MessageEnum.image,
              color: Colors.black,
              isReply: true,
              viewOnly: false,
            ),
          ),
        ),
      );

      // Verify icon is displayed in reply mode
      expect(find.byIcon(Icons.image), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets('renders video in reply mode correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DisplayMessageType(
              message: 'https://example.com/video.mp4',
              type: MessageEnum.video,
              color: Colors.black,
              isReply: true,
              viewOnly: false,
            ),
          ),
        ),
      );

      // Verify icon is displayed in reply mode
      expect(find.byIcon(Icons.video_collection), findsOneWidget);
      expect(find.byType(VideoPlayerWidget), findsNothing);
    });

    testWidgets('renders text message correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            ScreenUtil.init(context);
            return child!;
          },
          home: const Scaffold(
            body: DisplayMessageType(
              message: 'Hello, world!',
              type: MessageEnum.text,
              color: Colors.black,
              isReply: false,
              viewOnly: false,
            ),
          ),
        ),
      );

      // Verify text is displayed
      expect(find.text('Hello, world!'), findsOneWidget);
    });

    testWidgets('renders image message correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            ScreenUtil.init(context);
            return child!;
          },
          home: const Scaffold(
            body: DisplayMessageType(
              message: 'https://example.com/image.jpg',
              type: MessageEnum.image,
              color: Colors.black,
              isReply: false,
              viewOnly: false,
            ),
          ),
        ),
      );

      // Verify CachedNetworkImage is displayed
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('renders video message correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            ScreenUtil.init(context);
            return child!;
          },
          home: const Scaffold(
            body: DisplayMessageType(
              message: 'https://example.com/video.mp4',
              type: MessageEnum.video,
              color: Colors.black,
              isReply: false,
              viewOnly: false,
            ),
          ),
        ),
      );

      // Verify VideoPlayerWidget is displayed
      expect(find.byType(VideoPlayerWidget), findsOneWidget);
    });
  });
}
