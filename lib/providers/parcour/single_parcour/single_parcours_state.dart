import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'single_parcours_state.freezed.dart';

@freezed
class SingleParcoursState with _$SingleParcoursState {
  const factory SingleParcoursState.initial() = _Initial;
  const factory SingleParcoursState.loading() = _Loading;
  const factory SingleParcoursState.error(String message) = _Error;
  const factory SingleParcoursState.loaded(
      ParcoursWithGPSData data, UserModel owner) = _Loaded;
}
