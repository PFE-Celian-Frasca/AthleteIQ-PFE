import 'dart:async';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/providers/location/location_provider.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:athlete_iq/utils/parcour_utils.dart';
import 'package:athlete_iq/view/home_screen/provider/cluster_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';
part 'home_controller.freezed.dart';

@riverpod
class HomeController extends _$HomeController {
  StreamSubscription<List<ParcoursWithGPSData>>? _parcoursSubscription;

  @override
  HomeState build() {
    Future.microtask(() => init());
    ref.onDispose(() {
      _parcoursSubscription?.cancel();
    });
    return const HomeState();
  }

  Future<void> init() async {
    await ref.read(locationNotifierProvider.notifier).refreshLocation();
    await loadInitialParcours();
  }

  Future<void> loadInitialParcours() async {
    await setFilter("public"); // Default to public parcours
  }

  void setMapType(MapType type) {
    state = state.copyWith(mapType: type);
  }

  void toggleTraffic() {
    state = state.copyWith(trafficEnabled: !state.trafficEnabled);
  }

  void selectParcour(ParcoursWithGPSData parcour) {
    state = state.copyWith(
      selectedParcour: parcour,
      parcourOverlayVisible: true,
    );
  }

  void showClusterDialog(Set<ParcoursWithGPSData> items) {
    state = state.copyWith(
      showClusterDialog: true,
      clusterItems: items,
    );
  }

  void hideClusterDialog() {
    state = state.copyWith(showClusterDialog: false);
  }

  void closeParcourOverlay() {
    state = state.copyWith(parcourOverlayVisible: false);
  }

  void toggleMenu() {
    state = state.copyWith(isMenuOpen: !state.isMenuOpen);
  }

  void toggleMapType() {
    state =
        state.copyWith(mapType: state.mapType == MapType.normal ? MapType.hybrid : MapType.normal);
  }

  Future<void> setFilter(String filter) async {
    state = state.copyWith(selectedFilter: filter);

    final userId = ref.read(authRepositoryProvider).currentUser!.uid;
    final repository = ref.read(parcoursRepositoryProvider);

    Stream<List<ParcoursWithGPSData>> parcoursStream;

    switch (filter) {
      case "public":
        parcoursStream = repository.getPublicParcoursStream();
        break;
      case "private":
        parcoursStream = repository.getPrivateParcoursStream(userId);
        break;
      case "shared":
        parcoursStream = repository.getSharedParcoursStream(userId);
        break;
      case "favorites":
        parcoursStream = repository.getFavoritesParcoursStream(userId);
        break;
      default:
        throw Exception('Unknown filter type: $filter');
    }

    _parcoursSubscription?.cancel();
    _parcoursSubscription = parcoursStream.listen(
      (data) {
        updateMapElements(data);
      },
      onError: (Object err) =>
          ref.read(internalNotificationProvider).showErrorToast(err.toString()), // handle error
    );
  }

  void updateMapElements(List<ParcoursWithGPSData> parcoursList) {
    final clusterNotifier = ref.read(clusterNotifierProvider.notifier);
    clusterNotifier.updateClusters(parcoursList);
  }

  void updateCameraPosition(CameraPosition position) {
    state = state.copyWith(lastCameraPosition: position);
  }

  void checkOverlayVisibility() {
    if (state.parcourOverlayVisible &&
        state.selectedParcour != null &&
        state.lastCameraPosition != null) {
      final iconLocation = state.selectedParcour!.gpsData.first;
      final currentCameraPosition = state.lastCameraPosition!.target;
      final double distance = calculateDistance(
        currentCameraPosition.latitude,
        currentCameraPosition.longitude,
        iconLocation.latitude,
        iconLocation.longitude,
      );

      const double maxDistance = 5;

      if (distance > maxDistance) {
        closeParcourOverlay();
      }
    }
  }
}

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isMenuOpen,
    @Default(false) bool trafficEnabled,
    @Default(MapType.normal) MapType mapType,
    @Default(false) bool showClusterDialog,
    @Default(false) bool parcourOverlayVisible,
    ParcoursWithGPSData? selectedParcour,
    Set<ParcoursWithGPSData>? clusterItems,
    CameraPosition? lastCameraPosition,
    String? selectedFilter,
  }) = _HomeState;
}
