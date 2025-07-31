import 'package:athlete_iq/view/community/chat-page/components/generic_list_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple test model class
class TestItem {
  final String id;
  final String name;

  TestItem({required this.id, required this.name});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GenericListComponent', () {
    late List<TestItem> testItems;
    late List<String> selectedIds;
    late String excludeId;
    late TestItem? selectedItem;

    setUp(() {
      testItems = [
        TestItem(id: '1', name: 'Item 1'),
        TestItem(id: '2', name: 'Item 2'),
        TestItem(id: '3', name: 'Item 3'),
        TestItem(id: '4', name: 'Item 4'),
      ];
      selectedIds = ['1', '3'];
      excludeId = '4';
      selectedItem = null;
    });

    testWidgets('renders items correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericListComponent<TestItem>(
              onItemSelected: (item) => selectedItem = item,
              selectedIds: selectedIds,
              excludeId: excludeId,
              items: testItems,
              idExtractor: (item) => item.id,
              buildItem: (context, item) => Text(item.name),
              icon: const Icon(Icons.person),
            ),
          ),
        ),
      );
      
      // Verify items are displayed
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      
      // Verify excluded item is not displayed
      expect(find.text('Item 4'), findsNothing);
      
      // Verify icons are displayed
      expect(find.byIcon(Icons.person), findsNWidgets(3)); // 3 items shown
      
      // Verify checkboxes are displayed with correct values
      final checkboxes = tester.widgetList<Checkbox>(find.byType(Checkbox));
      expect(checkboxes.length, 3);
      expect(checkboxes.elementAt(0).value, isTrue); // Item 1 is selected
      expect(checkboxes.elementAt(1).value, isFalse); // Item 2 is not selected
      expect(checkboxes.elementAt(2).value, isTrue); // Item 3 is selected
    });

    testWidgets('calls onItemSelected when checkbox is tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericListComponent<TestItem>(
              onItemSelected: (item) => selectedItem = item,
              selectedIds: selectedIds,
              excludeId: excludeId,
              items: testItems,
              idExtractor: (item) => item.id,
              buildItem: (context, item) => Text(item.name),
              icon: const Icon(Icons.person),
            ),
          ),
        ),
      );
      
      // Tap the checkbox for Item 2
      await tester.tap(find.byType(Checkbox).at(1));
      
      // Verify onItemSelected was called with the correct item
      expect(selectedItem, isNotNull);
      expect(selectedItem!.id, equals('2'));
      expect(selectedItem!.name, equals('Item 2'));
    });

    testWidgets('handles empty items list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericListComponent<TestItem>(
              onItemSelected: (item) => selectedItem = item,
              selectedIds: selectedIds,
              excludeId: excludeId,
              items: const [], // Empty list
              idExtractor: (item) => item.id,
              buildItem: (context, item) => Text(item.name),
              icon: const Icon(Icons.person),
            ),
          ),
        ),
      );
      
      // Verify no items are displayed
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('handles all items excluded', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericListComponent<TestItem>(
              onItemSelected: (item) => selectedItem = item,
              selectedIds: selectedIds,
              excludeId: '1', // Exclude first item
              items: [testItems[0]], // Only include first item
              idExtractor: (item) => item.id,
              buildItem: (context, item) => Text(item.name),
              icon: const Icon(Icons.person),
            ),
          ),
        ),
      );
      
      // Verify no items are displayed
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('handles custom buildItem function', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericListComponent<TestItem>(
              onItemSelected: (item) => selectedItem = item,
              selectedIds: selectedIds,
              excludeId: excludeId,
              items: testItems,
              idExtractor: (item) => item.id,
              buildItem: (context, item) => Column(
                children: [
                  Text(item.name),
                  Text('ID: ${item.id}'),
                ],
              ),
              icon: const Icon(Icons.person),
            ),
          ),
        ),
      );
      
      // Verify custom item widgets are displayed
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('ID: 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('ID: 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.text('ID: 3'), findsOneWidget);
    });

    testWidgets('handles custom icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericListComponent<TestItem>(
              onItemSelected: (item) => selectedItem = item,
              selectedIds: selectedIds,
              excludeId: excludeId,
              items: testItems,
              idExtractor: (item) => item.id,
              buildItem: (context, item) => Text(item.name),
              icon: const Icon(Icons.star),
            ),
          ),
        ),
      );
      
      // Verify custom icon is displayed
      expect(find.byIcon(Icons.star), findsNWidgets(3)); // 3 items shown
      expect(find.byIcon(Icons.person), findsNothing);
    });
  });
}