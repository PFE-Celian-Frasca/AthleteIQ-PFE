import 'package:athlete_iq/utils/map_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

part 'location_data_model.freezed.dart';
part 'location_data_model.g.dart';

@freezed
class LocationDataModel with _$LocationDataModel {
  const factory LocationDataModel({
    required double latitude,
    required double longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? speedAccuracy,
    double? heading,
    double? time,
    double? verticalAccuracy,
    double? headingAccuracy,
    double? elapsedRealtimeNanos,
    double? elapsedRealtimeUncertaintyNanos,
    int? satelliteNumber,
    String? provider,
  }) = _LocationDataModel;

  factory LocationDataModel.fromJson(Map<String, dynamic> json) =>
      _$LocationDataModelFromJson(json);
}

List<LocationDataModel> locationDataToLocationDataModel(
    List<LocationData> locationData) {
  print(
      "locationDataToLocationDataModel${locationData.map((e) => LocationDataModel.fromJson(locationDataToMap(e))).toList()}");
  return locationData
      .map((e) => LocationDataModel.fromJson(locationDataToMap(e)))
      .toList();
}
