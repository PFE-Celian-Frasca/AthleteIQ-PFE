import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:location/location.dart';

import 'package:athlete_iq/providers/location/location_state.dart';
import 'package:athlete_iq/providers/location/location_provider.dart';
import 'package:athlete_iq/services/location_service.dart';

/// -------------------- mocks -----------------------------------------
class MockLocationService extends Mock implements LocationService {}

void main() {
  /// Mocktail a besoin d'exemples pour les types complexes/génériques
  setUpAll(() {
    // Valeur de repli pour LocationData
    registerFallbackValue(LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0}));

    // Valeur de repli pour Stream<LocationData>
    registerFallbackValue(
      const Stream<LocationData>.empty(),
    );
  });

  late MockLocationService mockLoc;
  late ProviderContainer container;
  late LocationNotifier notifier;

  setUp(() {
    mockLoc = MockLocationService();

    container = ProviderContainer(overrides: [
      locationServiceProvider.overrideWithValue(mockLoc),
    ]);
    addTearDown(container.dispose);

    notifier = container.read(locationNotifierProvider.notifier);
  });

  group('LocationNotifier', () {
    test('state initial = not loading', () {
      // L'état initial est isLoading: false, donc on adapte le test
      expect(notifier.state, const LocationState(isLoading: false));
    });

    test('refreshLocation met à jour locationData', () async {
      final loc = LocationData.fromMap({'latitude': 10.0, 'longitude': 20.0});

      when(() => mockLoc.getCurrentLocation()).thenAnswer((_) async => loc);

      await notifier.refreshLocation();

      expect(notifier.state.locationData, loc);
      expect(notifier.state.isLoading, false);
    });

    test('refreshLocation gère erreur', () async {
      when(() => mockLoc.getCurrentLocation()).thenThrow(Exception('gps off'));

      await notifier.refreshLocation();

      expect(notifier.state.isLoading, false);
      expect(notifier.state.locationData, isNull);
    });

    test('startTracking écoute le stream et maj state', () async {
      final loc = LocationData.fromMap({'latitude': 1.0, 'longitude': 2.0});

      when(() => mockLoc.locationStream).thenAnswer((_) => Stream.value(loc));
      when(() => mockLoc.startLocationTracking()).thenAnswer((_) async {});

      await notifier.startTracking();
      await Future<void>.delayed(
          const Duration(milliseconds: 1)); // Laisse le temps au stream d'être traité

      expect(notifier.state.isTracking, true);
      expect(notifier.state.locationData, loc);
    });

    test('stopTracking désactive le tracking', () async {
      // stream vide pour startTracking
      when(() => mockLoc.locationStream).thenAnswer((_) => const Stream.empty());
      when(() => mockLoc.startLocationTracking()).thenAnswer((_) async {});
      when(() => mockLoc.stopLocationTracking()).thenAnswer((_) async {});

      await notifier.startTracking();
      await notifier.stopTracking();

      expect(notifier.state.isTracking, false);
      verify(() => mockLoc.stopLocationTracking()).called(1);
    });
  });
}
