import 'package:athlete_iq/resources/components/ConfirmationDialog/custom_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomConfirmationDialog', () {
    testWidgets('renders with correct title and content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomConfirmationDialog(
              title: 'Confirm Action',
              content: 'Are you sure you want to proceed?',
              onConfirm: () {},
              onCancel: () {},
              confirmText: 'Yes',
            ),
          ),
        ),
      );

      expect(find.text('Confirm Action'), findsOneWidget);
      expect(find.text('Are you sure you want to proceed?'), findsOneWidget);
    });

    testWidgets('renders with default cancel text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomConfirmationDialog(
              title: 'Confirm Action',
              content: 'Are you sure you want to proceed?',
              onConfirm: () {},
              onCancel: () {},
              confirmText: 'Yes',
            ),
          ),
        ),
      );

      expect(find.text('Annuler'), findsOneWidget);
    });

    testWidgets('calls onConfirm when confirm button is pressed', (WidgetTester tester) async {
      bool confirmCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomConfirmationDialog(
              title: 'Confirm Action',
              content: 'Are you sure you want to proceed?',
              onConfirm: () => confirmCalled = true,
              onCancel: () {},
              confirmText: 'Yes',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Yes'));
      await tester.pump();

      expect(confirmCalled, isTrue);
    });

    testWidgets('calls onCancel when cancel button is pressed', (WidgetTester tester) async {
      bool cancelCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomConfirmationDialog(
              title: 'Confirm Action',
              content: 'Are you sure you want to proceed?',
              onConfirm: () {},
              onCancel: () => cancelCalled = true,
              confirmText: 'Yes',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Annuler'));
      await tester.pump();

      expect(cancelCalled, isTrue);
    });
  });
}