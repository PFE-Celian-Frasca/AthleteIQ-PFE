import 'package:athlete_iq/providers/location/location_provider.dart';
import 'package:athlete_iq/providers/location/location_state.dart';
import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'parcours_recording_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final parcoursRecordingNotifierProvider =
    StateNotifierProvider<ParcoursRecordingNotifier, ParcoursRecordingState>(
        (ref) {
  return ParcoursRecordingNotifier(ref);
});

class ParcoursRecordingNotifier extends StateNotifier<ParcoursRecordingState> {
  final Ref _ref;
  ProviderSubscription<dynamic>? _locationSubscription;

  ParcoursRecordingNotifier(this._ref) : super(const ParcoursRecordingState());

  Future<void> startRecording() async {
    if (state.isRecording) return;
    state = state.copyWith(isRecording: true);
    await WakelockPlus.enable();
    _locationSubscription =
        _ref.listen<LocationState>(locationNotifierProvider, (_, next) {
      if (next.locationData != null) {
        state = state.copyWith(
          recordedLocations: List.from(state.recordedLocations)
            ..add(next.locationData!),
        );
      }
    });
    _ref.read(timerProvider.notifier).startTimer();
    _ref.read(locationNotifierProvider.notifier).startTracking();
  }

  Future<void> stopRecording() async {
    _ref.read(locationNotifierProvider.notifier).stopTracking();
    _locationSubscription?.close();
    _locationSubscription = null;
    _ref.read(timerProvider.notifier).stopTimer();
    await WakelockPlus.disable();
    state = state.copyWith(isRecording: false);
  }

  void clearRecordedLocations() {
    state = state.copyWith(recordedLocations: []);
    _ref.read(timerProvider.notifier).resetTimer();
  }
}
