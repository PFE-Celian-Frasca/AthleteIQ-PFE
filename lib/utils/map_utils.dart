import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapUtils {
  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (final LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}

Map<String, dynamic> locationDataToMap(LocationData locationData) {
  return {
    'latitude': locationData.latitude,
    'longitude': locationData.longitude,
    'accuracy': locationData.accuracy,
    'altitude': locationData.altitude,
    'speed': locationData.speed,
    'speed_accuracy': locationData.speedAccuracy,
    'heading': locationData.heading,
    'time': locationData.time,
    'verticalAccuracy': locationData.verticalAccuracy,
    'headingAccuracy': locationData.headingAccuracy,
    'elapsedRealtimeNanos': locationData.elapsedRealtimeNanos,
    'elapsedRealtimeUncertaintyNanos': locationData.elapsedRealtimeUncertaintyNanos,
    'satelliteNumber': locationData.satelliteNumber,
    'provider': locationData.provider,
  };
}
