import 'package:athlete_iq/providers/google_map_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  group('googleMapControllerProvider', () {
    test('stocke et restitue un contrôleur par identifiant', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      const id1 = 'map-1';
      const id2 = 'map-2';

      expect(container.read(googleMapControllerProvider(id1)), isNull);

      final mockCtrl1 = MockGoogleMapController();
      container
          .read(googleMapControllerProvider(id1).notifier)
          .state = mockCtrl1;

      expect(container.read(googleMapControllerProvider(id1)), same(mockCtrl1));

      expect(container.read(googleMapControllerProvider(id2)), isNull);
    });
  });
}