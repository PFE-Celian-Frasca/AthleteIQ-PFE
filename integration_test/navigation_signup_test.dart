import 'package:athlete_iq/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('navigate to signup screen', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap on "Inscription" link
    final signupFinder = find.text('Inscription');
    expect(signupFinder, findsOneWidget);
    await tester.tap(signupFinder);
    await tester.pumpAndSettle();

    // Expect a button labeled "Créer un compte" on the signup screen
    expect(find.text('Créer un compte'), findsOneWidget);
  });
}
