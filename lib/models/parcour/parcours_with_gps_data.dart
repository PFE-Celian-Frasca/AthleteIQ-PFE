import 'package:freezed_annotation/freezed_annotation.dart';
import 'location_data_model.dart';
import 'parcours_model.dart';

part 'parcours_with_gps_data.freezed.dart';
part 'parcours_with_gps_data.g.dart'; // Pour le support JSON si nécessaire

@freezed
class ParcoursWithGPSData with _$ParcoursWithGPSData {
  const factory ParcoursWithGPSData({
    required ParcoursModel parcours,
    required List<LocationDataModel> gpsData,
  }) = _ParcoursWithGPSData;

  factory ParcoursWithGPSData.fromJson(Map<String, dynamic> json) =>
      _$ParcoursWithGPSDataFromJson(json);
}
