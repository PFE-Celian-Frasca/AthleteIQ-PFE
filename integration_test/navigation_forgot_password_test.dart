import 'package:athlete_iq/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('navigate to forgot password screen', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap on "Mot de passe oublié?" link
    final forgotFinder = find.text('Mot de passe oublié?');
    expect(forgotFinder, findsOneWidget);
    await tester.tap(forgotFinder);
    await tester.pumpAndSettle();

    // Verify presence of "Envoyer" button on forgot password screen
    expect(find.text('Envoyer'), findsOneWidget);
  });
}
