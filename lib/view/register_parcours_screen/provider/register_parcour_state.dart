import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_parcour_state.freezed.dart';

@freezed
class RegisterParcourState with _$RegisterParcourState {
  const factory RegisterParcourState({
    @Default(false) bool isLoading,
    @SportTypeConverter() @Default(SportType.marche) SportType sportType,
    @ParcourVisibilityConverter()
    @Default(ParcourVisibility.private)
    ParcourVisibility parcourType,
    @Default([]) List<String> friendsToShare,
    @Default([]) List<UserModel> friends,
    UserModel? owner,
    String? title,
    String? description,
    @Default([]) List<LocationDataModel> recordedLocations,
    double? totalDistance,
    double? maxAltitude,
    double? minAltitude,
    double? elevationGain,
    double? elevationLoss,
    double? minSpeed,
    double? maxSpeed,
    double? averageSpeed,
  }) = _RegisterParcourState;
}
