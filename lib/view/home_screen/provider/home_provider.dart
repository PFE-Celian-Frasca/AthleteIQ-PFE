import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/providers/parcour/parcours_provider.dart';
import 'cluter_provider.dart';
import 'home_state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(this._ref) : super(const HomeState());
  final Ref _ref;

  Future<void> loadInitialParcours() async {
    await setFilter("Public"); // Default to public parcours
  }

  void setMapType(MapType type) {
    state = state.copyWith(mapType: type);
  }

  void toggleTraffic() {
    state = state.copyWith(trafficEnabled: !state.trafficEnabled);
  }

  void selectParcour(ParcoursWithGPSData parcour) {
    state =
        state.copyWith(selectedParcour: parcour, parcourOverlayVisible: true);
  }

  void closeParcourOverlay() {
    state = state.copyWith(parcourOverlayVisible: false);
  }

  void toggleMenu() {
    state = state.copyWith(isMenuOpen: !state.isMenuOpen);
  }

  void toggleMapType() {
    state = state.copyWith(
        mapType: state.mapType == MapType.normal
            ? MapType.satellite
            : MapType.normal);
  }

  Future<void> setFilter(String filter) async {
    bool isFavorites = filter == "Favorites";
    ParcoursType? type;
    if (!isFavorites) {
      try {
        type = ParcoursType.values
            .firstWhere((t) => t.toString().split(".").last == filter);
      } catch (e) {
        type = null;
      }
    }

    state = state.copyWith(selectedFilter: filter);
    await _ref
        .read(parcoursProvider.notifier)
        .loadParcours(type: type, favorites: isFavorites)
        .then((_) => updateMapElementsBasedOnFilter(filter))
        .catchError((error) => print('Error loading parcours: $error'));
  }

  void updateMapElementsBasedOnFilter(String filter) {
    _ref.read(parcoursProvider).when(
        initial: () => {},
        loading: () => {},
        public: (parcoursList) {
          if (filter == "Public") updateMapElements(parcoursList);
        },
        private: (parcoursList) {
          if (filter == "Private") updateMapElements(parcoursList);
        },
        shared: (parcoursList) {
          if (filter == "Shared") updateMapElements(parcoursList);
        },
        favorites: (parcoursList) {
          if (filter == "Favorites") updateMapElements(parcoursList);
        },
        error: (message) => print('Error with parcours data: $message'),
        parcoursDetails: (details) => {});
  }

  void updateMapElements(List<ParcoursWithGPSData> parcoursList) {
    final clusterNotifier = _ref.read(clusterNotifierProvider.notifier);
    clusterNotifier.updateClusters(parcoursList);
  }
}
