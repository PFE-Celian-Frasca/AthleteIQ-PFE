import 'package:athlete_iq/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login form validation shows errors', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap the connexion button without filling the form
    final loginButton = find.text('Connexion');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify validation errors are displayed
    expect(find.text('Veillez entrer votre email'), findsOneWidget);
    expect(find.text('Entrez votre mot de passe'), findsOneWidget);
  });
}
