import 'package:athlete_iq/view/community/chat-page/components/custom_animated_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CustomAnimatedToggle', () {
    testWidgets('renders correctly when value is true', (tester) async {
      bool value = true;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedToggle(
              value: value,
              onChanged: (newValue) => value = newValue,
            ),
          ),
        ),
      );
      
      // Verify the toggle is rendered
      expect(find.byType(CustomAnimatedToggle), findsOneWidget);
      
      // Verify the container has the correct color
      final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.blue));
      
      // Verify the thumb is positioned on the right
      final animatedPositioned = tester.widget<AnimatedPositioned>(find.byType(AnimatedPositioned));
      expect(animatedPositioned.left, equals(30.0));
      expect(animatedPositioned.right, equals(0.0));
    });

    testWidgets('renders correctly when value is false', (tester) async {
      bool value = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedToggle(
              value: value,
              onChanged: (newValue) => value = newValue,
            ),
          ),
        ),
      );
      
      // Verify the toggle is rendered
      expect(find.byType(CustomAnimatedToggle), findsOneWidget);
      
      // Verify the container has the correct color
      final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.grey[400]));
      
      // Verify the thumb is positioned on the left
      final animatedPositioned = tester.widget<AnimatedPositioned>(find.byType(AnimatedPositioned));
      expect(animatedPositioned.left, equals(0.0));
      expect(animatedPositioned.right, equals(30.0));
    });

    testWidgets('calls onChanged with correct value when tapped', (tester) async {
      bool value = false;
      bool? newValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedToggle(
              value: value,
              onChanged: (val) => newValue = val,
            ),
          ),
        ),
      );
      
      // Tap the toggle
      await tester.tap(find.byType(GestureDetector));
      
      // Verify onChanged was called with the correct value
      expect(newValue, isTrue);
      
      // Reset and test the opposite case
      newValue = null;
      value = true;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomAnimatedToggle(
              value: value,
              onChanged: (val) => newValue = val,
            ),
          ),
        ),
      );
      
      // Tap the toggle
      await tester.tap(find.byType(GestureDetector));
      
      // Verify onChanged was called with the correct value
      expect(newValue, isFalse);
    });

    testWidgets('updates UI when value changes', (tester) async {
      bool value = false;
      
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return MaterialApp(
              home: Scaffold(
                body: CustomAnimatedToggle(
                  value: value,
                  onChanged: (newValue) {
                    setState(() {
                      value = newValue;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );
      
      // Verify initial state
      var container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      var decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.grey[400]));
      
      // Tap the toggle
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      
      // Verify the value changed
      expect(value, isTrue);
      
      // Verify the UI updated
      container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.blue));
      
      // Verify the animation starts
      var animatedPositioned = tester.widget<AnimatedPositioned>(find.byType(AnimatedPositioned));
      expect(animatedPositioned.left, equals(30.0));
      expect(animatedPositioned.right, equals(0.0));
      
      // Tap again to toggle back
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      
      // Verify the value changed back
      expect(value, isFalse);
      
      // Verify the UI updated
      container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.grey[400]));
      
      // Verify the animation starts
      animatedPositioned = tester.widget<AnimatedPositioned>(find.byType(AnimatedPositioned));
      expect(animatedPositioned.left, equals(0.0));
      expect(animatedPositioned.right, equals(30.0));
    });
  });
}