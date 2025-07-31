import 'package:athlete_iq/resources/components/Button/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTextButton', () {
    testWidgets('renders with correct text and styles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextButton(
              text: 'Click Me',
              onPressed: () {},
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ),
      );

      // Vérifie que le texte est affiché
      expect(find.text('Click Me'), findsOneWidget);

      // Vérifie que le bouton utilise les bonnes couleurs
      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      final textStyle = tester.widget<Text>(find.text('Click Me')).style;

      expect(textButton.style?.backgroundColor?.resolve({}), Colors.blue);
      expect(textStyle?.color, Colors.white);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextButton(
              text: 'Click Me',
              onPressed: () => wasPressed = true,
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ),
      );

      // Simule un appui sur le bouton
      await tester.tap(find.text('Click Me'));
      await tester.pump();

      // Vérifie que la fonction onPressed a été appelée
      expect(wasPressed, isTrue);
    });
  });
}