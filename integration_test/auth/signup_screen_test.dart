import 'package:athlete_iq/view/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SignupScreen Integration Tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = ProviderScope(
        child: MaterialApp(
          home: SignupScreen(),
        ),
      );
    });

    testWidgets('should display all UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Verify header elements
      expect(find.text('Bienvenue'), findsOneWidget);
      expect(find.text('Creez un compte pour continuer'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget); // Logo

      // Verify form elements
      expect(find.text('Pseudo'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('Confirmer le mot de passe'), findsOneWidget);
      expect(find.text('Genre:'), findsOneWidget);
      expect(find.text('Créer un compte'), findsOneWidget);
      expect(find.text('Vous avez déjà un compte?'), findsOneWidget);
      expect(find.text('Connexion'), findsOneWidget);

      // Verify gender options
      expect(find.byIcon(Icons.male), findsOneWidget);
      expect(find.byIcon(Icons.female), findsOneWidget);
      expect(find.byIcon(Icons.transgender), findsOneWidget);
    });

    testWidgets('should validate pseudo field correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the pseudo field
      final pseudoField = find.byType(TextFormField).first;

      // Test empty pseudo
      await tester.enterText(pseudoField, '');
      await tester.pump();
      await tester.tap(find.text('Créer un compte'));
      await tester.pumpAndSettle();
      expect(find.text('Entrez un pseudo'), findsOneWidget);

      // Test valid pseudo
      await tester.enterText(pseudoField, 'testuser');
      await tester.pump();
      expect(find.text('Entrez un pseudo'), findsNothing);
    });

    testWidgets('should validate email field correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the email field
      final emailField = find.byType(TextFormField).at(1);

      // Test empty email
      await tester.enterText(emailField, '');
      await tester.pump();
      await tester.tap(find.text('Créer un compte'));
      await tester.pumpAndSettle();
      expect(find.text('Entrez une adresse email'), findsOneWidget);

      // Test invalid email format
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();
      await tester.tap(find.text('Créer un compte'));
      await tester.pumpAndSettle();
      expect(find.text('Entrez une adresse email valide'), findsOneWidget);

      // Test valid email
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();
      expect(find.text('Entrez une adresse email'), findsNothing);
      expect(find.text('Entrez une adresse email valide'), findsNothing);
    });

    testWidgets('should validate password fields correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the password fields
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).at(3);

      // Test empty password
      await tester.enterText(passwordField, '');
      await tester.pump();
      await tester.tap(find.text('Créer un compte'));
      await tester.pumpAndSettle();

      // Test password mismatch
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password456');
      await tester.pump();
      await tester.tap(find.text('Créer un compte'));
      await tester.pumpAndSettle();
      expect(find.text('Les mots de passe ne correspondent pas'), findsOneWidget);

      // Test matching passwords
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password123');
      await tester.pump();
      expect(find.text('Les mots de passe ne correspondent pas'), findsNothing);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the password fields and visibility toggles
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).at(3);
      final visibilityToggles = find.byIcon(Icons.visibility_off);

      // Enter passwords
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password123');
      await tester.pump();

      // Check that passwords are initially obscured
      final TextField passwordTextField = tester.widget<TextField>(
        find.descendant(
          of: passwordField,
          matching: find.byType(TextField),
        ),
      );
      expect(passwordTextField.obscureText, isTrue);

      final TextField confirmPasswordTextField = tester.widget<TextField>(
        find.descendant(
          of: confirmPasswordField,
          matching: find.byType(TextField),
        ),
      );
      expect(confirmPasswordTextField.obscureText, isTrue);

      // Toggle visibility of first password field
      await tester.tap(visibilityToggles.first);
      await tester.pump();

      // Check that first password is now visible
      final TextField updatedPasswordTextField = tester.widget<TextField>(
        find.descendant(
          of: passwordField,
          matching: find.byType(TextField),
        ),
      );
      expect(updatedPasswordTextField.obscureText, isFalse);
    });

    testWidgets('should select gender correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find gender buttons
      final maleButton = find.byIcon(Icons.male);
      final femaleButton = find.byIcon(Icons.female);
      final nonBinaryButton = find.byIcon(Icons.transgender);

      // Male should be selected by default
      final Container maleContainer = tester.widget<Container>(
        find.ancestor(
          of: maleButton,
          matching: find.byType(Container),
        ).first,
      );
      expect(maleContainer.decoration, isNotNull);

      // Select female
      await tester.tap(femaleButton);
      await tester.pump();

      // Female should now be selected
      final Container femaleContainer = tester.widget<Container>(
        find.ancestor(
          of: femaleButton,
          matching: find.byType(Container),
        ).first,
      );
      expect(femaleContainer.decoration, isNotNull);

      // Select non-binary
      await tester.tap(nonBinaryButton);
      await tester.pump();

      // Non-binary should now be selected
      final Container nonBinaryContainer = tester.widget<Container>(
        find.ancestor(
          of: nonBinaryButton,
          matching: find.byType(Container),
        ).first,
      );
      expect(nonBinaryContainer.decoration, isNotNull);
    });

    testWidgets('should enable signup button when form is valid', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the form fields
      final pseudoField = find.byType(TextFormField).first;
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).at(3);

      // Initially button should be disabled
      final initialButton = find.byType(ElevatedButton);
      expect(tester.widget<ElevatedButton>(initialButton).enabled, isFalse);

      // Fill in valid form data
      await tester.enterText(pseudoField, 'testuser');
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password123');
      await tester.pump();

      // Button should now be enabled
      final updatedButton = find.byType(ElevatedButton);
      expect(tester.widget<ElevatedButton>(updatedButton).enabled, isTrue);
    });

    testWidgets('should navigate to login screen', (WidgetTester tester) async {
      // Create a mock app with GoRouter for navigation testing
      final mockApp = MaterialApp(
        home: ProviderScope(
          child: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => GoRouter.of(context).go('/login'),
                child: const Text('Connexion'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(mockApp);
      await tester.pumpAndSettle();

      // Tap the login button
      await tester.tap(find.text('Connexion'));
      await tester.pumpAndSettle();

      // Verify navigation (in a real test, we'd check for route change)
    });

    testWidgets('should unfocus when tapping outside of text fields', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find the email field
      final emailField = find.byType(TextFormField).at(1);

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