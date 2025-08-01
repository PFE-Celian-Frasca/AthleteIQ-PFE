import 'package:athlete_iq/resources/components/animated_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimatedBar', () {
    testWidgets('renders with width 30 when isActive is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedBar(isActive: true),
          ),
        ),
      );

      final animatedBar = find.byType(AnimatedContainer);
      final containerWidget = tester.widget<AnimatedContainer>(animatedBar);

      expect(containerWidget.constraints?.maxWidth, 30);
    });

    testWidgets('renders with width 0 when isActive is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedBar(isActive: false),
          ),
        ),
      );

      final animatedBar = find.byType(AnimatedContainer);
      final containerWidget = tester.widget<AnimatedContainer>(animatedBar);

      expect(containerWidget.constraints?.maxWidth, 0);
    });

    testWidgets('renders with correct border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedBar(isActive: true),
          ),
        ),
      );

      final animatedBar = find.byType(AnimatedContainer);
      final containerWidget = tester.widget<AnimatedContainer>(animatedBar);
      final boxDecoration = containerWidget.decoration as BoxDecoration;

      expect(boxDecoration.borderRadius, BorderRadius.circular(12));
    });
  });
}
