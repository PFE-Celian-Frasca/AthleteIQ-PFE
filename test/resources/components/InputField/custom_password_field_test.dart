import 'package:athlete_iq/resources/components/InputField/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomPasswordField', () {
    testWidgets('renders with correct label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CustomPasswordField(
                context: context,
                label: 'Password',
                isObscure: true,
                toggleObscure: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders with lock icon as prefix', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CustomPasswordField(
                context: context,
                label: 'Password',
                isObscure: true,
                toggleObscure: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    });

    testWidgets('toggles obscure text when suffix icon is pressed', (WidgetTester tester) async {
      bool isObscure = true;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return CustomPasswordField(
                    context: context,
                    label: 'Password',
                    isObscure: isObscure,
                    toggleObscure: () => setState(() => isObscure = !isObscure),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (WidgetTester tester) async {
      String? capturedValue;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CustomPasswordField(
                context: context,
                label: 'Password',
                isObscure: true,
                toggleObscure: () {},
                onChanged: (value) => capturedValue = value,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'NewPassword');
      expect(capturedValue, 'NewPassword');
    });

    testWidgets('applies validator and shows error message when invalid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: Form(
                key: GlobalKey<FormState>(),
                child: CustomPasswordField(
                  context: context,
                  label: 'Password',
                  isObscure: true,
                  toggleObscure: () {},
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Password is required' : null,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      // Appelle explicitement la validation du formulaire
      final formState = tester.state<FormState>(find.byType(Form));
      formState.validate();
      await tester.pump();

      expect(find.text('Password is required'), findsOneWidget);
    });
  });
}
