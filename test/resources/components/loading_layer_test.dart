import 'package:athlete_iq/resources/components/loading_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingLayer', () {
    testWidgets('renders child widget correctly', (WidgetTester tester) async {
      const child = Text('Child Widget');
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingLayer(child: child),
        ),
      );

      expect(find.text('Child Widget'), findsOneWidget);
    });

    testWidgets('displays loading indicator on top of child', (WidgetTester tester) async {
      const child = Text('Child Widget');
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingLayer(child: child),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Child Widget'), findsOneWidget);
    });
  });
}
