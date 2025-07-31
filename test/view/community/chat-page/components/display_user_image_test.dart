import 'dart:io';
import 'package:athlete_iq/view/community/chat-page/components/display_user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFile extends Mock implements File {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DisplayUserImage', () {
    late bool onPressedCalled;

    setUp(() {
      onPressedCalled = false;
    });

    testWidgets('renders correctly when finalFileImage is not null', (tester) async {
      // Create a mock file
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/image.jpg');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisplayUserImage(
              finalFileImage: mockFile,
              radius: 50,
              onPressed: () => onPressedCalled = true,
            ),
          ),
        ),
      );
      
      // Verify user image is displayed
      expect(find.byType(CircleAvatar), findsNWidgets(2)); // Main avatar and camera button
      
      // Verify camera button is displayed with correct color
      final cameraAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar).at(1));
      expect(cameraAvatar.backgroundColor, equals(Colors.green));
      
      // Verify camera icon is displayed
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      
      // Tap the camera button
      await tester.tap(find.byType(InkWell));
      
      // Verify onPressed was called
      expect(onPressedCalled, isTrue);
    });

    testWidgets('uses correct radius for CircleAvatar', (tester) async {
      const testRadius = 75.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisplayUserImage(
              finalFileImage: null,
              radius: testRadius,
              onPressed: () => onPressedCalled = true,
            ),
          ),
        ),
      );
      
      // Verify main avatar has correct radius
      final mainAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar).first);
      expect(mainAvatar.radius, equals(testRadius));
    });
  });
}