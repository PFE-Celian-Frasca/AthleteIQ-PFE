import 'package:athlete_iq/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AthleteIQ app', () {
    testWidgets('launch app and display home', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.byType(app.MyApp), findsOneWidget);
    });
  });
}
