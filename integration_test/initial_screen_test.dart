import 'package:athlete_iq/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app starts on login screen', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // The login screen contains a button labeled "Connexion"
    expect(find.text('Connexion'), findsOneWidget);
  });
}
