import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import '../../services/location_service.dart';
import 'location_state.dart'; // Assurez-vous que le chemin d'accès est correct

final locationNotifierProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier(ref);
});

class LocationNotifier extends StateNotifier<LocationState> {
  final Ref _ref;
  StreamSubscription<LocationData>? _locationSubscription;

  LocationNotifier(this._ref) : super(const LocationState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      final locationData =
          await _ref.read(locationServiceProvider).getCurrentLocation();
      state = state.copyWith(locationData: locationData, isLoading: false);
    } catch (error) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshLocation({bool forceRefresh = false}) async {
    if (state.locationData != null && !forceRefresh) {
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final locationData =
          await _ref.read(locationServiceProvider).getCurrentLocation();
      state = state.copyWith(locationData: locationData, isLoading: false);
    } catch (error) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> startTracking() async {
    if (state.isTracking) return;

    await _ref.read(locationServiceProvider).startLocationTracking();
    _locationSubscription = _ref
        .read(locationServiceProvider)
        .locationStream
        .listen((locationData) {
      state = state.copyWith(locationData: locationData);
    });
    state = state.copyWith(isTracking: true);
  }

  Future<void> stopTracking() async {
    await _ref.read(locationServiceProvider).stopLocationTracking();
    await _locationSubscription?.cancel();
    state = state.copyWith(isTracking: false);
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
