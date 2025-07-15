import 'package:athlete_iq/services/location_service.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TestLocation extends Fake implements Location {
  PermissionStatus permission = PermissionStatus.denied;
  bool service = false;
  bool background = false;
  final controller = StreamController<LocationData>();

  @override
  Stream<LocationData> get onLocationChanged => controller.stream;

  @override
  Future<LocationData> getLocation() async =>
      LocationData.fromMap({'latitude': 1.0, 'longitude': 2.0});

  @override
  Future<PermissionStatus> hasPermission() async => permission;

  @override
  Future<PermissionStatus> requestPermission() async {
    permission = PermissionStatus.granted;
    return permission;
  }

  @override
  Future<bool> serviceEnabled() async => service;

  @override
  Future<bool> requestService() async {
    service = true;
    return service;
  }

  @override
  Future<bool> enableBackgroundMode({bool? enable = true}) async {
    background = enable ?? true;
    return background;
  }
}

void main() {
  test('provider returns LocationService', () {
    final container = ProviderContainer(overrides: [
      locationServiceProvider.overrideWith((ref) => LocationService(TestLocation()))
    ]);
    expect(container.read(locationServiceProvider), isA<ILocationService>());
  });
  test('ensurePermissionGranted requests permission when denied', () async {
    final location = TestLocation();
    final service = LocationService(location);
    final result = await service.ensurePermissionGranted();
    expect(result, isTrue);
    expect(location.permission, PermissionStatus.granted);
  });

  test('ensureLocationServiceEnabled requests service when disabled', () async {
    final location = TestLocation();
    final service = LocationService(location);
    final result = await service.ensureLocationServiceEnabled();
    expect(result, isTrue);
    expect(location.service, isTrue);
  });

  test('getCurrentLocation returns data when permitted', () async {
    final location = TestLocation()
      ..permission = PermissionStatus.granted
      ..service = true;
    final service = LocationService(location);
    final data = await service.getCurrentLocation();
    expect(data, isNotNull);
  });

  test('start and stop tracking toggle isTracking', () async {
    final location = TestLocation()
      ..permission = PermissionStatus.granted
      ..service = true;
    final service = LocationService(location);
    await service.startLocationTracking();
    expect(service.isTracking, isTrue);
    location.controller.add(LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0}));
    await service.stopLocationTracking();
    expect(service.isTracking, isFalse);
    expect(location.background, isFalse);
  });

  test('locationStream emits events', () async {
    final location = TestLocation();
    final service = LocationService(location);
    final future = service.locationStream.first;
    location.controller.add(LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0}));
    expect(await future, isA<LocationData>());
  });
}
