import 'dart:math';

import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/utils/speed_converter.dart';
import 'package:athlete_iq/view/parcour-detail/provider/user_weight_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:athlete_iq/models/parcour/parcours_model.dart';

final caloriesBurnedProvider = Provider.family<double, ParcoursModel>((ref, parcour) {
  final userWeight = ref.watch(
      userWeightProvider); // Supposons que vous ayez un provider pour le poids de l'utilisateur
  return calculateCaloriesBurned(parcour, userWeight);
});

double calculateMaxSpeed(List<LocationDataModel> parcour) {
  final double maxSpeed =
      parcour.map((e) => e.speed ?? 0).reduce((curr, next) => curr > next ? curr : next);
  return toKmH(speed: maxSpeed); // Assurez-vous que la fonction toKmH existe et est correcte
}

double calculateMinSpeed(List<LocationDataModel> parcour) {
  final double minSpeed = parcour
      .map((e) => e.speed ?? double.infinity)
      .reduce((curr, next) => curr < next ? curr : next);
  return toKmH(speed: minSpeed); // Assurez-vous que la fonction toKmH existe et est correcte
}

double? calculateMaxAltitude(List<LocationDataModel> parcour) {
  final double? maxAlt =
      parcour.map((e) => e.altitude).reduce((curr, next) => curr! > next! ? curr : next);
  return maxAlt;
}

double? calculateMinAltitude(List<LocationDataModel> parcour) {
  final double? minAlt =
      parcour.map((e) => e.altitude).reduce((curr, next) => curr! < next! ? curr : next);
  return minAlt;
}

double calculateCaloriesBurned(ParcoursModel parcour, double userWeight) {
  final double durationInHours =
      parcour.timer.hours + (parcour.timer.minutes / 60) + (parcour.timer.seconds / 3600);
  final double avgSpeed = calculateAverageSpeed(
      totalDistance: parcour.totalDistance, timer: parcour.timer); // Implémentez cette fonction

  return (avgSpeed * userWeight * durationInHours * 0.24);
}

double calculateAverageSpeed({required double totalDistance, required CustomTimer timer}) {
  final double durationInHours = timer.hours + (timer.minutes / 60) + (timer.seconds / 3600);
  return totalDistance / durationInHours;
}

double calculateTotalElevationGain(List<LocationDataModel> parcour) {
  double totalElevationGain = 0;
  for (int i = 0; i < parcour.length - 1; i++) {
    final double diff = parcour[i + 1].altitude! - parcour[i].altitude!;
    if (diff > 0) {
      totalElevationGain += diff;
    }
  }
  return totalElevationGain;
}

double calculateTotalElevationLoss(List<LocationDataModel> parcour) {
  double totalElevationLoss = 0;
  for (int i = 0; i < parcour.length - 1; i++) {
    final double diff = parcour[i].altitude! - parcour[i + 1].altitude!;
    if (diff > 0) {
      totalElevationLoss += diff;
    }
  }
  return totalElevationLoss;
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295; // Pi/180
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}

double calculateTotalDistance(List<LocationDataModel> locations) {
  double totalDistance = 0.0;
  for (int i = 0; i < locations.length - 1; i++) {
    totalDistance += calculateDistance(
      locations[i].latitude,
      locations[i].longitude,
      locations[i + 1].latitude,
      locations[i + 1].longitude,
    );
  }
  return totalDistance;
}

String printDuration(ParcoursModel parcour) {
  return DateFormat.Hms().format(
    DateTime(0, 0, 0, parcour.timer.hours, parcour.timer.minutes, parcour.timer.seconds),
  );
}
