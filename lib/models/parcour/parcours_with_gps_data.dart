import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_data_model.dart';
import 'parcours_model.dart';

part 'parcours_with_gps_data.freezed.dart';
part 'parcours_with_gps_data.g.dart';

@freezed
class ParcoursWithGPSData with _$ParcoursWithGPSData implements ClusterItem {
  const ParcoursWithGPSData._();
  const factory ParcoursWithGPSData({
    required ParcoursModel parcours,
    required List<LocationDataModel> gpsData,
  }) = _ParcoursWithGPSData;

  factory ParcoursWithGPSData.fromJson(Map<String, dynamic> json) =>
      _$ParcoursWithGPSDataFromJson(json);

  @override
  LatLng get location => LatLng(gpsData.first.latitude, gpsData.first.longitude);

  String? getId() => parcours.id;

  @override
  String get geohash => Geohash.encode(latLng: location, codeLength: 12);
}
