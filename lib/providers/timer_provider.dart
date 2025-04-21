import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/timer/custom_timer.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, CustomTimer>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<CustomTimer> {
  TimerNotifier() : super(const CustomTimer());

  Timer? _timer;
  bool isRunning = false;
  void startTimer() {
    _timer?.cancel();
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        seconds: (state.seconds + 1) % 60,
        minutes: (state.seconds + 1) == 60
            ? (state.minutes + 1) % 60
            : state.minutes,
        hours: (state.minutes + 1) == 60 && (state.seconds + 1) == 60
            ? state.hours + 1
            : state.hours,
      );
    });
  }

  void stopTimer() {
    if (!isRunning) return; // Only stop if running
    _timer?.cancel();
    isRunning = false;
  }

  void resetTimer() {
    stopTimer();
    state = const CustomTimer();
  }
}
