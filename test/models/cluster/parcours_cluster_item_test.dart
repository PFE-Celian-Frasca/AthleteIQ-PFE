import 'package:athlete_iq/models/cluster/parcours_cluster_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group('ParcoursClusterItem', () {
    // Vérifie que les propriétés sont correctement initialisées
    test('initializes properties correctly', () {
      const item = ParcoursClusterItem(
        id: '1',
        position: LatLng(48.8566, 2.3522),
        icon: BitmapDescriptor.defaultMarker,
        title: 'Paris',
        snippet: 'Capital of France',
        allPoints: [LatLng(48.8566, 2.3522), LatLng(48.8584, 2.2945)],
      );

      expect(item.id, '1');
      expect(item.position, const LatLng(48.8566, 2.3522));
      expect(item.icon, BitmapDescriptor.defaultMarker);
      expect(item.title, 'Paris');
      expect(item.snippet, 'Capital of France');
      expect(item.allPoints.length, 2);
    });

    // Vérifie le comportement avec une liste de points vide
    test('handles empty allPoints list gracefully', () {
      const item = ParcoursClusterItem(
        id: '2',
        position: LatLng(48.8566, 2.3522),
        icon: BitmapDescriptor.defaultMarker,
        title: 'Empty Points',
        snippet: 'No points available',
        allPoints: [],
      );

      expect(item.allPoints.isEmpty, true);
    });

    // Vérifie le comportement avec un geohash valide
    test('generates valid geohash', () {
      const item = ParcoursClusterItem(
        id: '3',
        position: LatLng(48.8566, 2.3522),
        icon: BitmapDescriptor.defaultMarker,
        title: 'Geohash Test',
        snippet: 'Testing geohash generation',
        allPoints: [LatLng(48.8566, 2.3522)],
      );

      expect(item.geohash.length, 12);
    });

    // Vérifie le comportement avec un titre vide
    test('handles empty title gracefully', () {
      const item = ParcoursClusterItem(
        id: '4',
        position: LatLng(48.8566, 2.3522),
        icon: BitmapDescriptor.defaultMarker,
        title: '',
        snippet: 'No title provided',
        allPoints: [LatLng(48.8566, 2.3522)],
      );

      expect(item.title, '');
    });

    // Vérifie le comportement avec un snippet vide
    test('handles empty snippet gracefully', () {
      const item = ParcoursClusterItem(
        id: '5',
        position: LatLng(48.8566, 2.3522),
        icon: BitmapDescriptor.defaultMarker,
        title: 'Empty Snippet',
        snippet: '',
        allPoints: [LatLng(48.8566, 2.3522)],
      );

      expect(item.snippet, '');
    });
  });
}