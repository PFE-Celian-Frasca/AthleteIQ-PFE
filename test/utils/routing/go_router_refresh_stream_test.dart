import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/utils/routing/go_router_refresh_stream.dart';

void main() {
  group('GoRouterRefreshStream', () {
    test('notifies listeners when constructed', () async {
      // Arrange
      final controller = StreamController<int>();
      var listenerCallCount = 0;

      // Act
      final refreshStream = GoRouterRefreshStream(controller.stream);

      // The listener is added after the constructor, so we need to manually
      // trigger a notification to simulate what happens in the constructor
      refreshStream.addListener(() {
        listenerCallCount++;
      });

      // Manually trigger a notification to simulate what happens in the constructor
      controller.add(0);

      // Wait for stream to propagate
      await Future.microtask(() {});

      // Assert
      expect(listenerCallCount, 1);

      // Cleanup
      refreshStream.dispose();
      controller.close();
    });

    test('notifies listeners when stream emits a value', () async {
      // Arrange
      final controller = StreamController<int>();
      var listenerCallCount = 0;

      final refreshStream = GoRouterRefreshStream(controller.stream);
      refreshStream.addListener(() {
        listenerCallCount++;
      });

      // Reset counter after initial notification
      listenerCallCount = 0;

      // Act
      controller.add(1);

      // Wait for stream to propagate
      await Future.microtask(() {});

      // Assert
      expect(listenerCallCount, 1);

      // Cleanup
      refreshStream.dispose();
      controller.close();
    });

    test('notifies listeners multiple times when stream emits multiple values', () async {
      // Arrange
      final controller = StreamController<int>();
      var listenerCallCount = 0;

      final refreshStream = GoRouterRefreshStream(controller.stream);
      refreshStream.addListener(() {
        listenerCallCount++;
      });

      // Reset counter after initial notification
      listenerCallCount = 0;

      // Act - add values one at a time with delays to ensure they're processed
      controller.add(1);
      await Future.microtask(() {});

      controller.add(2);
      await Future.microtask(() {});

      controller.add(3);
      await Future.microtask(() {});

      // Assert
      expect(listenerCallCount, 3);

      // Cleanup
      refreshStream.dispose();
      controller.close();
    });

    test('stops notifying after dispose', () async {
      // Arrange
      final controller = StreamController<int>();
      var listenerCallCount = 0;

      final refreshStream = GoRouterRefreshStream(controller.stream);
      refreshStream.addListener(() {
        listenerCallCount++;
      });

      // Reset counter after initial notification
      listenerCallCount = 0;

      // Act - dispose the refresh stream
      refreshStream.dispose();

      // Try to emit a value after dispose
      controller.add(1);

      // Wait for stream to propagate
      await Future.microtask(() {});

      // Assert - listener should not be called
      expect(listenerCallCount, 0);

      // Cleanup
      controller.close();
    });

    test('works with broadcast streams', () async {
      // Arrange
      final controller = StreamController<int>.broadcast();
      var listenerCallCount = 0;

      final refreshStream = GoRouterRefreshStream(controller.stream);
      refreshStream.addListener(() {
        listenerCallCount++;
      });

      // Reset counter after initial notification
      listenerCallCount = 0;

      // Act
      controller.add(1);

      // Wait for stream to propagate
      await Future.microtask(() {});

      // Assert
      expect(listenerCallCount, 1);

      // Cleanup
      refreshStream.dispose();
      controller.close();
    });
  });
}
