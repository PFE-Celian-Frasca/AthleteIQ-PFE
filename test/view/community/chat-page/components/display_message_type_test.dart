import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/view/community/chat-page/components/display_message_type.dart';
import 'package:athlete_iq/view/community/chat-page/components/video_player_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
  });
}
