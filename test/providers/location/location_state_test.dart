import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:athlete_iq/providers/location/location_state.dart';

void main() {
  group('LocationState', () {
    test('initializes with default values', () {
      const state = LocationState();
      expect(state.isLoading, false);
      expect(state.isTracking, false);
      expect(state.locationData, isNull);
    });

    test('updates loading state correctly', () {
      const state = LocationState(isLoading: true);
      expect(state.isLoading, true);
    });

    test('updates tracking state correctly', () {
      const state = LocationState(isTracking: true);
      expect(state.isTracking, true);
    });

    test('accepts location data', () {
      final locationData = LocationData.fromMap({'latitude': 10.0, 'longitude': 20.0});
      final state = LocationState(locationData: locationData);
      expect(state.locationData, locationData);
    });

    test('handles null location data', () {
      const state = LocationState(locationData: null);
      expect(state.locationData, isNull);
    });
  });
}
