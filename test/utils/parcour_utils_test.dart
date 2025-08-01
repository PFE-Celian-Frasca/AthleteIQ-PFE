import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/utils/parcour_utils.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/enums/enums.dart';

void main() {
  final points = [
    const LocationDataModel(latitude: 0, longitude: 0, speed: 1, altitude: 10),
    const LocationDataModel(latitude: 0, longitude: 1, speed: 2, altitude: 20),
    const LocationDataModel(latitude: 0, longitude: 2, speed: 3, altitude: 15),
    const LocationDataModel(latitude: 0, longitude: 3, speed: 4, altitude: 30),
  ];

  group('speed and altitude', () {
    test('max speed', () {
      expect(calculateMaxSpeed(points), closeTo(14.4, 0.01));
    });

    test('min speed', () {
      expect(calculateMinSpeed(points), closeTo(3.6, 0.01));
    });

    test('max altitude', () {
      expect(calculateMaxAltitude(points), 30);
    });

    test('min altitude', () {
      expect(calculateMinAltitude(points), 10);
    });
  });

  test('total elevation gain and loss', () {
    expect(calculateTotalElevationGain(points), 25);
    expect(calculateTotalElevationLoss(points), 5);
  });

  test('distance calculations', () {
    expect(calculateDistance(0, 0, 0, 1), closeTo(111.19, 0.01));
    expect(calculateTotalDistance(points), closeTo(333.58, 0.1));
  });

  test('average speed and calories', () {
    final parcours = ParcoursModel(
      owner: '1',
      title: 'test',
      type: ParcourVisibility.public,
      sportType: SportType.marche,
      shareTo: const [],
      timer: const CustomTimer(hours: 1, minutes: 30, seconds: 0),
      createdAt: DateTime(2024, 1, 1),
      vm: 0,
      totalDistance: 10,
    );
    expect(calculateAverageSpeed(totalDistance: 10, timer: parcours.timer), closeTo(6.66, 0.01));
    expect(calculateCaloriesBurned(parcours, 70), closeTo(168, 0.1));
    expect(printDuration(parcours), '01:30:00');
  });
}
