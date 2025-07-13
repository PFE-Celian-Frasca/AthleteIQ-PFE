import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:location/location.dart';

void main() {
  group('LocationDataModel', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      const location = LocationDataModel(
        latitude: 48.8566,
        longitude: 2.3522,
        accuracy: 5.0,
        altitude: 35.0,
        speed: 10.0,
        speedAccuracy: 0.5,
        heading: 90.0,
        time: 1633036800.0,
        verticalAccuracy: 3.0,
        headingAccuracy: 1.0,
        elapsedRealtimeNanos: 1234567890.0,
        elapsedRealtimeUncertaintyNanos: 0.1,
        satelliteNumber: 12,
        provider: 'gps',
      );

      expect(location.latitude, 48.8566);
      expect(location.longitude, 2.3522);
      expect(location.accuracy, 5.0);
      expect(location.altitude, 35.0);
      expect(location.speed, 10.0);
      expect(location.speedAccuracy, 0.5);
      expect(location.heading, 90.0);
      expect(location.time, 1633036800.0);
      expect(location.verticalAccuracy, 3.0);
      expect(location.headingAccuracy, 1.0);
      expect(location.elapsedRealtimeNanos, 1234567890.0);
      expect(location.elapsedRealtimeUncertaintyNanos, 0.1);
      expect(location.satelliteNumber, 12);
      expect(location.provider, 'gps');
    });

    // Vérifie le comportement avec des valeurs nulles
    test('handles null values gracefully', () {
      const location = LocationDataModel(
        latitude: 48.8566,
        longitude: 2.3522,
        accuracy: null,
        altitude: null,
        speed: null,
        speedAccuracy: null,
        heading: null,
        time: null,
        verticalAccuracy: null,
        headingAccuracy: null,
        elapsedRealtimeNanos: null,
        elapsedRealtimeUncertaintyNanos: null,
        satelliteNumber: null,
        provider: null,
      );

      expect(location.accuracy, null);
      expect(location.altitude, null);
      expect(location.speed, null);
      expect(location.speedAccuracy, null);
      expect(location.heading, null);
      expect(location.time, null);
      expect(location.verticalAccuracy, null);
      expect(location.headingAccuracy, null);
      expect(location.elapsedRealtimeNanos, null);
      expect(location.elapsedRealtimeUncertaintyNanos, null);
      expect(location.satelliteNumber, null);
      expect(location.provider, null);
    });

    // Vérifie le comportement avec des coordonnées invalides
    test('handles invalid coordinates gracefully', () {
      const location = LocationDataModel(
        latitude: -91.0,
        longitude: 181.0,
        accuracy: 5.0,
        altitude: 35.0,
        speed: 10.0,
        speedAccuracy: 0.5,
        heading: 90.0,
        time: 1633036800.0,
        verticalAccuracy: 3.0,
        headingAccuracy: 1.0,
        elapsedRealtimeNanos: 1234567890.0,
        elapsedRealtimeUncertaintyNanos: 0.1,
        satelliteNumber: 12,
        provider: 'gps',
      );

      expect(location.latitude, -91.0);
      expect(location.longitude, 181.0);
    });

    // Vérifie le comportement avec une liste de données de localisation
    test('converts location data list to models correctly', () {
      final locationDataList = [
        LocationData.fromMap(const {
          'latitude': 48.8566,
          'longitude': 2.3522,
          'accuracy': 5.0,
        }),
        LocationData.fromMap(const {
          'latitude': 40.7128,
          'longitude': -74.0060,
          'accuracy': 10.0,
        }),
      ];

      final models = locationDataToLocationDataModel(locationDataList);

      expect(models.length, 2);
      expect(models[0].latitude, 48.8566);
      expect(models[0].longitude, 2.3522);
      expect(models[0].accuracy, 5.0);
      expect(models[1].latitude, 40.7128);
      expect(models[1].longitude, -74.0060);
      expect(models[1].accuracy, 10.0);
    });
  });
}
