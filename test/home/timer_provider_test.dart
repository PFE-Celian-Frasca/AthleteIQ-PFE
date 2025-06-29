import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimerNotifier', () {
    test('startTimer increments time', () {
      fakeAsync((async) {
        final notifier = TimerNotifier();
        notifier.startTimer();
        expect(notifier.isRunning, true);
        async.elapse(const Duration(seconds: 3));
        expect(notifier.state.seconds, 3);
        notifier.stopTimer();
      });
    });

    test('stopTimer stops ticking', () {
      fakeAsync((async) {
        final notifier = TimerNotifier();
        notifier.startTimer();
        async.elapse(const Duration(seconds: 2));
        notifier.stopTimer();
        final secondsAfterStop = notifier.state.seconds;
        async.elapse(const Duration(seconds: 2));
        expect(notifier.state.seconds, secondsAfterStop);
        expect(notifier.isRunning, false);
      });
    });
  });
}

