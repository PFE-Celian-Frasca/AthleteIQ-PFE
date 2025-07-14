import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wakelock_plus_platform_interface/wakelock_plus_platform_interface.dart';

import 'package:athlete_iq/providers/parcour_recording/parcours_recording_provider.dart';
import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:athlete_iq/services/location_service.dart';
import 'package:athlete_iq/providers/parcour_recording/parcours_recording_state.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';

class MockLocationService extends Mock implements ILocationService {}

class FakeTimerNotifier extends TimerNotifier {
  bool startCalled = false;
  bool stopCalled = false;
  bool resetCalled = false;

  @override
  void startTimer() {
    startCalled = true;
  }

  @override
  void stopTimer() {
    stopCalled = true;
  }

  @override
  void resetTimer() {
    resetCalled = true;
    state = const CustomTimer();
  }
}

class FakeWakelockPlatform extends Fake implements WakelockPlusPlatformInterface {
  bool enabledFlag = false;

  @override
  bool get isMock => true;

  @override
  Future<void> toggle({required bool enable}) async {
    enabledFlag = enable;
  }

  @override
  Future<bool> get enabled async => enabledFlag;
}

void main() {
  setUpAll(() {
    registerFallbackValue(LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0}));
    registerFallbackValue(const Stream<LocationData>.empty());
  });

  late MockLocationService mockLocService;
  late FakeTimerNotifier fakeTimer;
  late FakeWakelockPlatform wakelock;
  late ProviderContainer container;
  late ParcoursRecordingNotifier notifier;
  late StreamController<LocationData> locController;

  setUp(() {
    mockLocService = MockLocationService();
    fakeTimer = FakeTimerNotifier();
    wakelock = FakeWakelockPlatform();
    wakelockPlusPlatformInstance = wakelock;

    locController = StreamController<LocationData>();

    when(() => mockLocService.locationStream).thenAnswer((_) => locController.stream);
    when(() => mockLocService.startLocationTracking()).thenAnswer((_) async {});
    when(() => mockLocService.stopLocationTracking()).thenAnswer((_) async {});
    when(() => mockLocService.getCurrentLocation()).thenAnswer((_) async => null);

    container = ProviderContainer(overrides: [
      locationServiceProvider.overrideWithValue(mockLocService),
      timerProvider.overrideWith((ref) => fakeTimer),
    ]);
    addTearDown(container.dispose);

    notifier = container.read(parcoursRecordingNotifierProvider.notifier);
  });

  group('ParcoursRecordingNotifier', () {
    test('startRecording active le suivi et enregistre les positions', () async {
      final loc = LocationData.fromMap({'latitude': 1.0, 'longitude': 2.0});

      final states = <ParcoursRecordingState>[];
      container.listen(parcoursRecordingNotifierProvider, (_, next) => states.add(next),
          fireImmediately: true);

      await notifier.startRecording();
      await container.pump();
      locController.add(loc);
      await container.pump();

      expect(states.last.isRecording, isTrue);
      final last = states.last.recordedLocations.last;
      expect(last.latitude, loc.latitude);
      expect(last.longitude, loc.longitude);
      expect(fakeTimer.startCalled, isTrue);
      expect(wakelock.enabledFlag, isTrue);
      verify(() => mockLocService.startLocationTracking()).called(1);
    });

    test('stopRecording arrête le suivi et ne stocke plus de positions', () async {
      final loc1 = LocationData.fromMap({'latitude': 1.0, 'longitude': 2.0});
      final loc2 = LocationData.fromMap({'latitude': 3.0, 'longitude': 4.0});

      await notifier.startRecording();
      await container.pump();
      locController.add(loc1);
      await container.pump();

      await notifier.stopRecording();
      locController.add(loc2);
      await container.pump();

      final state = container.read(parcoursRecordingNotifierProvider);
      expect(state.isRecording, isFalse);
      expect(state.recordedLocations.length, 1);
      expect(state.recordedLocations.first.latitude, loc1.latitude);
      expect(state.recordedLocations.first.longitude, loc1.longitude);
      expect(fakeTimer.stopCalled, isTrue);
      expect(wakelock.enabledFlag, isFalse);
      verify(() => mockLocService.stopLocationTracking()).called(1);
    });

    test('clearRecordedLocations vide la liste et réinitialise le timer', () async {
      final loc = LocationData.fromMap({'latitude': 1.0, 'longitude': 2.0});

      await notifier.startRecording();
      await container.pump();
      locController.add(loc);
      await container.pump();

      notifier.clearRecordedLocations();
      final state = container.read(parcoursRecordingNotifierProvider);
      expect(state.recordedLocations, isEmpty);
      expect(fakeTimer.resetCalled, isTrue);
    });
  });
}
