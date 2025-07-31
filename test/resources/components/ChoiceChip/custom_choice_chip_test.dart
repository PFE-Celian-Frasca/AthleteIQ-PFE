import 'package:athlete_iq/resources/components/ChoiceChip/custom_choice_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomChoiceChipSelector', () {
    testWidgets('renders with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomChoiceChipSelector<int>(
              title: 'Select an option',
              options: const {1: 'Option 1', 2: 'Option 2'},
              selectedValue: 1,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select an option'), findsOneWidget);
    });

    testWidgets('renders all choice chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomChoiceChipSelector<int>(
              title: 'Select an option',
              options: const {1: 'Option 1', 2: 'Option 2'},
              selectedValue: 1,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('calls onSelected when a chip is tapped', (WidgetTester tester) async {
      int? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomChoiceChipSelector<int>(
              title: 'Select an option',
              options: const {1: 'Option 1', 2: 'Option 2'},
              selectedValue: 1,
              onSelected: (value) => selectedValue = value,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Option 2'));
      await tester.pump();

      expect(selectedValue, 2);
    });

    testWidgets('applies correct style to selected chip', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomChoiceChipSelector<int>(
              title: 'Select an option',
              options: const {1: 'Option 1', 2: 'Option 2'},
              selectedValue: 1,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      final selectedChip = find.byWidgetPredicate(
            (widget) =>
        widget is ChoiceChip &&
            widget.label is Text &&
            (widget.label as Text).data == 'Option 1' &&
            widget.selected,
      );

      final unselectedChip = find.byWidgetPredicate(
            (widget) =>
        widget is ChoiceChip &&
            widget.label is Text &&
            (widget.label as Text).data == 'Option 2' &&
            !widget.selected,
      );

      expect(selectedChip, findsOneWidget);
      expect(unselectedChip, findsOneWidget);
    });
  });
}