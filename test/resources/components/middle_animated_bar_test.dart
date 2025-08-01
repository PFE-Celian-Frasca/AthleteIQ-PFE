import 'package:athlete_iq/resources/components/middle_animated_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MiddleAnimatedBar', () {
    testWidgets('renders with active state correctly', (WidgetTester tester) async {
      const widget = MiddleAnimatedBar(isActive: true);

      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      final animatedContainer = find.byType(AnimatedContainer);
      expect(animatedContainer, findsOneWidget);

      final renderBox = tester.renderObject<RenderBox>(animatedContainer);
      expect(renderBox.size.width, 60);
      expect(renderBox.size.height, 2);
    });

    testWidgets('renders with inactive state correctly', (WidgetTester tester) async {
      const widget = MiddleAnimatedBar(isActive: false);

      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      final animatedContainer = find.byType(AnimatedContainer);
      expect(animatedContainer, findsOneWidget);

      final renderBox = tester.renderObject<RenderBox>(animatedContainer);
      expect(renderBox.size.width, 0);
      expect(renderBox.size.height, 2);
    });

    testWidgets('applies correct color from theme', (WidgetTester tester) async {
      const widget = MiddleAnimatedBar(isActive: true);

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(colorScheme: const ColorScheme.light(primary: Colors.red)),
        home: const Scaffold(body: widget),
      ));

      final animatedContainer = find.byType(AnimatedContainer);
      final containerWidget = tester.widget<AnimatedContainer>(animatedContainer);
      final decoration = containerWidget.decoration as BoxDecoration;

      expect(decoration.color, Colors.red);
    });
  });
}
