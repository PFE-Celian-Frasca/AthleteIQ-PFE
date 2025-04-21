import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

part 'parcours_recording_state.freezed.dart';

@freezed
class ParcoursRecordingState with _$ParcoursRecordingState {
  const factory ParcoursRecordingState({
    @Default([]) List<LocationData> recordedLocations,
    @Default(false) bool isRecording,
  }) = _ParcoursRecordingState;
}
