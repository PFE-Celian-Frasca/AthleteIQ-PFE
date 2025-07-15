import 'package:athlete_iq/utils/utils_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class FakeRouter extends Fake implements GoRouter {
  bool popped = false;
  String? navigated;

  @override
  void pop<T extends Object?>([T? result]) {
    popped = true;
  }

  @override
  void go(String location, {Object? extra}) {
    navigated = location;
  }
}

void main() {
  testWidgets('navigateBackOrToMain pops when possible', (tester) async {
    final router = FakeRouter();
    await tester.pumpWidget(InheritedGoRouter(
      goRouter: router,
      child: MaterialApp(
        routes: {
          '/second': (_) => Builder(builder: (context) {
                return TextButton(
                  onPressed: () => navigateBackOrToMain(context),
                  child: const Text('back'),
                );
              }),
        },
        home: Builder(builder: (context) {
          return TextButton(
            onPressed: () => Navigator.pushNamed(context, '/second'),
            child: const Text('go'),
          );
        }),
      ),
    ));

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('back'));
    expect(router.popped, isTrue);
  });

  testWidgets('navigateBackOrToMain goes home when cannot pop', (tester) async {
    final router = FakeRouter();
    await tester.pumpWidget(InheritedGoRouter(
      goRouter: router,
      child: MaterialApp(
        home: Builder(builder: (context) {
          return TextButton(
            onPressed: () => navigateBackOrToMain(context),
            child: const Text('tap'),
          );
        }),
      ),
    ));

    await tester.tap(find.text('tap'));
    expect(router.navigated, '/home');
  });
}
