import 'package:athlete_iq/utils/map_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  test('boundsFromLatLngList returns correct bounds', () {
    final list = [
      const LatLng(0, 0),
      const LatLng(1, 2),
      const LatLng(-1, 3),
    ];
    final bounds = MapUtils.boundsFromLatLngList(list);
    expect(bounds.northeast, const LatLng(1, 3));
    expect(bounds.southwest, const LatLng(-1, 0));
  });

  test('locationDataToMap converts values correctly', () {
    final data = LocationData.fromMap({
      'latitude': 1.0,
      'longitude': 2.0,
      'accuracy': 3.0,
      'altitude': 4.0,
      'speed': 5.0,
      'speed_accuracy': 6.0,
      'heading': 7.0,
      'time': 8.0,
      'verticalAccuracy': 9.0,
      'headingAccuracy': 10.0,
      'elapsedRealtimeNanos': 11.0,
      'elapsedRealtimeUncertaintyNanos': 12.0,
      'satelliteNumber': 13,
      'provider': 'gps',
    });
    final map = locationDataToMap(data);
    expect(map['latitude'], 1.0);
    expect(map['provider'], 'gps');
    expect(map['elapsedRealtimeNanos'], 11.0);
  });
}
