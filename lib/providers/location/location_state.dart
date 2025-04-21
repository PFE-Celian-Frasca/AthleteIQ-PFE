// location_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

part 'location_state.freezed.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState({
    @Default(false) bool isLoading,
    LocationData? locationData,
    @Default(false) bool isTracking,
  }) = _LocationState;
}
