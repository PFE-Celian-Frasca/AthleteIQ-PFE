import 'package:athlete_iq/resources/components/InputField/custom_input_field.dart'
    show CustomInputField;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomInputField', () {
    testWidgets('renders with correct label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CustomInputField(
                context: context,
                label: 'Username',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('renders with prefix icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CustomInputField(
                context: context,
                label: 'Username',
                icon: Icons.person,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (WidgetTester tester) async {
      String? capturedValue;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CustomInputField(
                context: context,
                label: 'Username',
                onChanged: (value) => capturedValue = value,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'NewValue');
      expect(capturedValue, 'NewValue');
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
                child: CustomInputField(
                  context: context,
                  label: 'Username',
                  validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      final formState = tester.state<FormState>(find.byType(Form));
      formState.validate();
      await tester.pump();

      expect(find.text('Field is required'), findsOneWidget);
    });
  });
}
