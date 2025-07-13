import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group('ParcoursWithGPSData', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      final parcours = ParcoursModel(
        id: "default",
        owner: 'user123',
        title: 'Morning Run',
        type: ParcourVisibility.public,
        sportType: SportType.course,
        shareTo: ['friend1', 'friend2'],
        timer: const CustomTimer(
          hours: 0,
          minutes: 30,
          seconds: 0,
        ),
        createdAt: DateTime.now(),
        vm: 0.0,
        totalDistance: 5.0,
      );
      final gpsData = [
        const LocationDataModel(latitude: 48.8566, longitude: 2.3522, accuracy: 5.0),
        const LocationDataModel(latitude: 40.7128, longitude: -74.0060, accuracy: 10.0),
      ];
      final parcoursWithGPSData = ParcoursWithGPSData(parcours: parcours, gpsData: gpsData);

      expect(parcoursWithGPSData.parcours.id, "default");
      expect(parcoursWithGPSData.parcours.title, 'Morning Run');
      expect(parcoursWithGPSData.gpsData.length, 2);
      expect(parcoursWithGPSData.gpsData.first.latitude, 48.8566);
      expect(parcoursWithGPSData.gpsData.first.longitude, 2.3522);
    });

    // Vérifie le comportement avec des données GPS vides
    test('handles empty gpsData gracefully', () {
      final parcours = ParcoursModel(
        id: "default",
        owner: 'user123',
        title: 'Morning Run',
        type: ParcourVisibility.public,
        sportType: SportType.course,
        shareTo: ['friend1', 'friend2'],
        timer: const CustomTimer(
          hours: 0,
          minutes: 30,
          seconds: 0,
        ),
        createdAt: DateTime.now(),
        vm: 0.0,
        totalDistance: 5.0,
      );
      final gpsData = <LocationDataModel>[];
      final parcoursWithGPSData = ParcoursWithGPSData(parcours: parcours, gpsData: gpsData);

      expect(parcoursWithGPSData.gpsData.isEmpty, true);
    });

    // Vérifie le comportement avec une latitude et longitude invalides
    test('handles invalid latitude and longitude gracefully', () {
      final parcours = ParcoursModel(
        id: "default",
        owner: 'user123',
        title: 'Morning Run',
        type: ParcourVisibility.public,
        sportType: SportType.course,
        shareTo: ['friend1', 'friend2'],
        timer: const CustomTimer(
          hours: 0,
          minutes: 30,
          seconds: 0,
        ),
        createdAt: DateTime.now(),
        vm: 0.0,
        totalDistance: 5.0,
      );
      final gpsData = [
        const LocationDataModel(latitude: -91.0, longitude: 181.0, accuracy: 5.0),
      ];
      final parcoursWithGPSData = ParcoursWithGPSData(parcours: parcours, gpsData: gpsData);

      expect(parcoursWithGPSData.gpsData.first.latitude, -91.0);
      expect(parcoursWithGPSData.gpsData.first.longitude, 181.0);
    });

    // Vérifie la génération correcte de l'objet LatLng
    test('generates correct LatLng object', () {
      final parcours = ParcoursModel(
        id: "default",
        owner: 'user123',
        title: 'Morning Run',
        type: ParcourVisibility.public,
        sportType: SportType.course,
        shareTo: ['friend1', 'friend2'],
        timer: const CustomTimer(
          hours: 0,
          minutes: 30,
          seconds: 0,
        ),
        createdAt: DateTime.now(),
        vm: 0.0,
        totalDistance: 5.0,
      );
      final gpsData = [
        const LocationDataModel(latitude: 48.8566, longitude: 2.3522, accuracy: 5.0),
      ];
      final parcoursWithGPSData = ParcoursWithGPSData(parcours: parcours, gpsData: gpsData);

      expect(parcoursWithGPSData.location, const LatLng(48.8566, 2.3522));
    });

    // Vérifie la génération correcte du geohash
    test('generates correct geohash', () {
      final parcours = ParcoursModel(
        id: "default",
        owner: 'user123',
        title: 'Morning Run',
        type: ParcourVisibility.public,
        sportType: SportType.course,
        shareTo: ['friend1', 'friend2'],
        timer: const CustomTimer(
          hours: 0,
          minutes: 30,
          seconds: 0,
        ),
        createdAt: DateTime.now(),
        vm: 0.0,
        totalDistance: 5.0,
      );
      final gpsData = [
        const LocationDataModel(latitude: 48.8566, longitude: 2.3522, accuracy: 5.0),
      ];
      final parcoursWithGPSData = ParcoursWithGPSData(parcours: parcours, gpsData: gpsData);

      expect(parcoursWithGPSData.geohash, isNotEmpty);
    });
  });
}