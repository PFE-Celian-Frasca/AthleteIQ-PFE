import 'package:athlete_iq/resources/components/Button/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomFloatingButton', () {
    testWidgets('renders with correct icon and background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              floatingActionButton: CustomFloatingButton(
                onPressed: () {},
                backgroundColor: Colors.blue,
                icon: Icons.add,
                iconColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Vérifie que l'icône est affichée
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Vérifie que la couleur de fond est correcte
      final fab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
      expect(fab.backgroundColor, Colors.blue);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              floatingActionButton: CustomFloatingButton(
                onPressed: () => wasPressed = true,
                backgroundColor: Colors.blue,
                icon: Icons.add,
              ),
            ),
          ),
        ),
      );

      // Simule un appui sur le bouton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Vérifie que la fonction onPressed a été appelée
      expect(wasPressed, isTrue);
    });

    testWidgets('renders loading widget when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              floatingActionButton: CustomFloatingButton(
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
