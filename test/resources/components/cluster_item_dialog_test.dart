import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/resources/components/cluster_item_dialog.dart';

void main() {
  group('ClusterItemsDialog', () {
    testWidgets('ferme le dialogue lorsque le bouton de fermeture est cliqué', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ClusterItemsDialog(
            clusterItems: {},
            onSelectParcour: (_) {},
          ),
        ),
      );

      final closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);

      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(find.byType(ClusterItemsDialog), findsNothing);
    });
  });
}
