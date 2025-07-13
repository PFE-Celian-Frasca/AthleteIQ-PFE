import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:athlete_iq/models/timer/custom_timer.dart';

void main() {
  group('TimerNotifier', () {
    test('état initial = 0 h 0 m 0 s & not running', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final timer = container.read(timerProvider);
      final notifier = container.read(timerProvider.notifier);

      expect(timer, const CustomTimer());
      expect(notifier.isRunning, isFalse);
    });

    test('startTimer incrémente secondes → minutes → heures', () {
      fakeAsync((async) {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(timerProvider.notifier);

        notifier.startTimer();

        // +1 s
        async.elapse(const Duration(seconds: 1));
        expect(container.read(timerProvider), const CustomTimer(seconds: 1));

        // +59 s (total 60) → 1 min 0 s
        async.elapse(const Duration(seconds: 59));
        expect(container.read(timerProvider), const CustomTimer(minutes: 1));

        // +59 min 60 s (soit 1 h 1 m) → 1 h 1 m 0 s
        async.elapse(const Duration(minutes: 59, seconds: 60));
        expect(container.read(timerProvider),
            const CustomTimer(hours: 1, minutes: 1));
      });
    });

    test('stopTimer arrête l’incrément', () {
      fakeAsync((async) {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(timerProvider.notifier);

        notifier.startTimer();
        async.elapse(const Duration(seconds: 3));
        notifier.stopTimer();                    // stop ici
        final valAfterStop = container.read(timerProvider);

        async.elapse(const Duration(seconds: 5)); // ne doit plus bouger
        expect(container.read(timerProvider), same(valAfterStop));
        expect(notifier.isRunning, isFalse);
      });
    });

    test('resetTimer remet à zéro & stoppe le timer', () {
      fakeAsync((async) {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(timerProvider.notifier);

        notifier.startTimer();
        async.elapse(const Duration(seconds: 10));
        notifier.resetTimer();

        expect(container.read(timerProvider), const CustomTimer());
        expect(notifier.isRunning, isFalse);
      });
    });
  });
}