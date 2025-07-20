import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:athlete_iq/utils/routing/custom_popup_route.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockAnimation extends Mock implements Animation<double> {
  @override
  double get value => 1.0;
}

void main() {
  group('CustomPopupRoute', () {
    late CustomPopupRoute route;

    setUp(() {
      route = CustomPopupRoute(
        builder: (context) => const Text('Test Widget'),
      );
    });

    test('has correct barrier properties', () {
      expect(route.barrierColor, equals(Colors.black54.withAlpha(100)));
      expect(route.barrierDismissible, isTrue);
      expect(route.barrierLabel, equals('customPopupRoute'));
    });

    test('buildPage returns widget from builder', () {
      final BuildContext context = MockBuildContext();
      final Animation<double> animation = MockAnimation();
      final Animation<double> secondaryAnimation = MockAnimation();

      final Widget result = route.buildPage(context, animation, secondaryAnimation);

      // Verify that the builder was called with the context
      expect(result, isA<Text>());
      expect((result as Text).data, equals('Test Widget'));
    });

    testWidgets('buildTransitions creates ScaleTransition', (WidgetTester tester) async {
      final BuildContext context = MockBuildContext();
      final Animation<double> animation = MockAnimation();
      final Animation<double> secondaryAnimation = MockAnimation();
      const Widget child = Text('Child Widget');

      final Widget result = route.buildTransitions(context, animation, secondaryAnimation, child);

      expect(result, isA<ScaleTransition>());

      // Verify that the ScaleTransition uses the provided animation
      final ScaleTransition transition = result as ScaleTransition;
      expect(transition.scale, equals(animation));

      // Verify that the child is used
      expect(transition.child, equals(child));
    });

    test('has correct transition duration', () {
      expect(route.transitionDuration, equals(const Duration(milliseconds: 150)));
    });
  });
}

