import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/parcour/parcours_with_gps_data.dart';

part 'parcours_state.freezed.dart';

@freezed
class ParcoursState with _$ParcoursState {
  const factory ParcoursState.initial() = _Initial;
  const factory ParcoursState.loading() = _Loading;
  const factory ParcoursState.public(List<ParcoursWithGPSData> publicParcours) =
      _Public;
  const factory ParcoursState.private(
      List<ParcoursWithGPSData> privateParcours) = _Private;
  const factory ParcoursState.shared(List<ParcoursWithGPSData> sharedParcours) =
      _Shared;
  const factory ParcoursState.error(String message) = _Error;
  const factory ParcoursState.favorites(List<ParcoursWithGPSData> favorites) =
      _Favorites;
  // État pour un seul parcours avec données GPS
  const factory ParcoursState.parcoursDetails(
      ParcoursWithGPSData parcoursDetails) = _ParcoursDetails;
}
