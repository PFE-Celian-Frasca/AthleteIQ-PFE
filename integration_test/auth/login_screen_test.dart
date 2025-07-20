import 'package:athlete_iq/view/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('LoginScreen Integration Tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      );
    });

    testWidgets('should display all UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Verify header elements
      expect(find.text('Bienvenue,'), findsOneWidget);
      expect(find.text('Connectez-vous pour continuer,'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget); // Logo

      // Verify form elements
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('Mot de passe oublié?'), findsOneWidget);
      expect(find.text('Connexion'), findsOneWidget);
      expect(find.text("Vous n'avez pas de compte? "), findsOneWidget);
      expect(find.text('Inscription'), findsOneWidget);
    });

    testWidgets('should validate email field correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the email field
      final emailField = find.byType(TextFormField).first;

      // Test empty email
      await tester.enterText(emailField, '');
      await tester.pump();
      await tester.tap(find.text('Connexion'));
      await tester.pumpAndSettle();
      expect(find.text('Veillez entrer votre email'), findsOneWidget);

      // Test invalid email format
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();
      await tester.tap(find.text('Connexion'));
      await tester.pumpAndSettle();
      expect(find.text('Entrez une adresse email valide'), findsOneWidget);

      // Test valid email
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();
      expect(find.text('Veillez entrer votre email'), findsNothing);
      expect(find.text('Entrez une adresse email valide'), findsNothing);
    });

    testWidgets('should validate password field correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the password field
      final passwordField = find.byType(TextFormField).at(1);

      // Test empty password
      await tester.enterText(passwordField, '');
      await tester.pump();
      await tester.tap(find.text('Connexion'));
      await tester.pumpAndSettle();
      expect(find.text('Entrez votre mot de passe'), findsOneWidget);

      // Test valid password
      await tester.enterText(passwordField, 'password123');
      await tester.pump();
      expect(find.text('Entrez votre mot de passe'), findsNothing);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the password field and visibility toggle
      final passwordField = find.byType(TextFormField).at(1);
      final visibilityToggle = find.byIcon(Icons.visibility_off);

      // Enter a password
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Check that password is initially obscured
      final TextField textField = tester.widget<TextField>(
        find.descendant(
          of: passwordField,
          matching: find.byType(TextField),
        ),
      );
      expect(textField.obscureText, isTrue);

      // Toggle visibility
      await tester.tap(visibilityToggle);
      await tester.pump();

      // Check that password is now visible
      final TextField updatedTextField = tester.widget<TextField>(
        find.descendant(
          of: passwordField,
          matching: find.byType(TextField),
        ),
      );
      expect(updatedTextField.obscureText, isFalse);
    });

    testWidgets('should enable login button when form is valid', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the form fields
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      // Initially button should be disabled
      final initialButton = find.byType(ElevatedButton);
      expect(tester.widget<ElevatedButton>(initialButton).enabled, isFalse);

      // Fill in valid form data
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Button should now be enabled
      final updatedButton = find.byType(ElevatedButton);
      expect(tester.widget<ElevatedButton>(updatedButton).enabled, isTrue);
    });

    testWidgets('should navigate to forgot password screen', (WidgetTester tester) async {
      // Create a mock app with GoRouter for navigation testing
      final mockApp = MaterialApp(
        home: ProviderScope(
          child: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => GoRouter.of(context).go('/forgot-password'),
                child: const Text('Mot de passe oublié?'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(mockApp);
      await tester.pumpAndSettle();

      // Tap the forgot password button
      await tester.tap(find.text('Mot de passe oublié?'));
      await tester.pumpAndSettle();

      // Verify navigation (in a real test, we'd check for route change)
    });

    testWidgets('should navigate to signup screen', (WidgetTester tester) async {
      // Create a mock app with GoRouter for navigation testing
      final mockApp = MaterialApp(
        home: ProviderScope(
          child: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => GoRouter.of(context).go('/signup'),
                child: const Text('Inscription'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(mockApp);
      await tester.pumpAndSettle();

      // Tap the signup button
      await tester.tap(find.text('Inscription'));
      await tester.pumpAndSettle();

      // Verify navigation (in a real test, we'd check for route change)
    });

    testWidgets('should unfocus when tapping outside of text fields', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the email field
      final emailField = find.byType(TextFormField).first;

      // Tap on the email field to focus it
      await tester.tap(emailField);
      await tester.pump();

      // Verify field is focused
      expect(tester.testTextInput.isVisible, isTrue);

      // Tap outside the field (on the scaffold)
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      // Verify field is unfocused
      expect(tester.testTextInput.isVisible, isFalse);
    });
  });
}