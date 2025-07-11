import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';

abstract class ILocationService {
  Future<LocationData?> getCurrentLocation();
  Stream<LocationData> get locationStream;
  Future<void> startLocationTracking();
  Future<void> stopLocationTracking();
  Future<bool> ensureLocationServiceEnabled();
  Future<bool> ensurePermissionGranted();
  bool get isTracking;
}

final locationServiceProvider = Provider<ILocationService>((ref) {
  return LocationService();
});

class LocationService implements ILocationService {
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  bool _isTracking = false;

  @override
  Future<LocationData?> getCurrentLocation() async {
    if (!await ensureLocationServiceEnabled() || !await ensurePermissionGranted()) {
      return null;
    }
    return await _location.getLocation();
  }

  @override
  Stream<LocationData> get locationStream => _location.onLocationChanged;

  @override
  Future<void> startLocationTracking() async {
    if (_isTracking || !await ensureLocationServiceEnabled() || !await ensurePermissionGranted()) {
      return;
    }
    _isTracking = true;
    _location.enableBackgroundMode(enable: true);
    _locationSubscription = _location.onLocationChanged.listen((locationData) {});
  }

  @override
  Future<void> stopLocationTracking() async {
    if (!_isTracking) return;
    _isTracking = false;
    await _locationSubscription?.cancel();
    _location.enableBackgroundMode(enable: false);
  }

  @override
  Future<bool> ensureLocationServiceEnabled() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return serviceEnabled;
  }

  @override
  Future<bool> ensurePermissionGranted() async {
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted;
  }

  @override
  bool get isTracking => _isTracking;
}
