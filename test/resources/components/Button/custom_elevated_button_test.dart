import 'package:athlete_iq/resources/components/Button/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomElevatedButton', () {
    testWidgets('renders loading widget when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CustomElevatedButton(
                onPressed: () {},
                backgroundColor: Colors.blue,
                loadingWidget: const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );

      // Vérifie que le widget de chargement est affiché
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
