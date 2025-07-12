import 'package:athlete_iq/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
class TestLocation extends Fake implements Location {
  PermissionStatus permission = PermissionStatus.denied;
  bool service = false;

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
}

void main() {
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
}
