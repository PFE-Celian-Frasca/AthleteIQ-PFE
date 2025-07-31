import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomAppBar', () {
    testWidgets('renders title when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(title: 'Test Title'),
          ),
        ),
      );

      final titleFinder = find.text('Test Title');
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('does not render title when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(),
          ),
        ),
      );

      final titleFinder = find.byType(Text);
      expect(titleFinder, findsNothing);
    });

    testWidgets('renders back button when hasBackButton is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(hasBackButton: true),
          ),
        ),
      );

      final backButtonFinder = find.byType(IconButton);
      expect(backButtonFinder, findsOneWidget);
    });

    testWidgets('does not render back button when hasBackButton is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(hasBackButton: false),
          ),
        ),
      );

      final backButtonFinder = find.byType(IconButton);
      expect(backButtonFinder, findsNothing);
    });

    testWidgets('calls onBackButtonPressed when back button is tapped', (WidgetTester tester) async {
      var wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              hasBackButton: true,
              onBackButtonPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      final backButtonFinder = find.byType(IconButton);
      await tester.tap(backButtonFinder);
      expect(wasPressed, isTrue);
    });

    testWidgets('renders actions when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              actions: [Icon(Icons.settings)],
            ),
          ),
        ),
      );

      final actionFinder = find.byIcon(Icons.settings);
      expect(actionFinder, findsOneWidget);
    });

    testWidgets('does not render actions when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(),
          ),
        ),
      );

      final actionFinder = find.byType(Icon);
      expect(actionFinder, findsNothing);
    });
  });
}