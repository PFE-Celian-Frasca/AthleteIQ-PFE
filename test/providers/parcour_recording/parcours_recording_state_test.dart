import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';

import 'package:athlete_iq/providers/parcour_recording/parcours_recording_state.dart';

void main() {
  group('ParcoursRecordingState', () {
    test('valeurs par défaut', () {
      const state = ParcoursRecordingState();

      expect(state.isRecording, isFalse);
      expect(state.recordedLocations, isEmpty);
    });

    test('construction personnalisée', () {
      final sampleLocations = [
        LocationData.fromMap({'latitude': 48.86, 'longitude': 2.35}),
        LocationData.fromMap({'latitude': 48.87, 'longitude': 2.34}),
      ];

      final state = ParcoursRecordingState(
        recordedLocations: sampleLocations,
        isRecording: true,
      );

      expect(state.isRecording, isTrue);
      expect(state.recordedLocations, sampleLocations);
    });
  });
}
