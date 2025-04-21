import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';

part 'combined_parcours_state.freezed.dart';

@freezed
class CombinedParcoursState with _$CombinedParcoursState {
  const factory CombinedParcoursState({
    @Default(false) bool isLoading,
    List<ParcoursWithGPSData>? loadedParcours,
    List<ParcoursWithGPSData>? favoritesParcours,
    String? error,
  }) = _CombinedParcoursState;
}
