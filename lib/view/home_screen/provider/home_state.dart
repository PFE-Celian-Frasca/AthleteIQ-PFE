import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(MapType.normal) MapType mapType,
    @Default(false) bool trafficEnabled,
    @Default(false) bool isMenuOpen,
    ParcoursWithGPSData? selectedParcour,
    @Default(false) bool parcourOverlayVisible,
    String? selectedFilter,
  }) = _HomeState;
}
