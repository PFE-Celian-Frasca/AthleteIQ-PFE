import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_parcour_state.freezed.dart';

@freezed
class UpdateParcourState with _$UpdateParcourState {
  const factory UpdateParcourState({
    @Default(false) bool isLoading,
    @ParcourVisibilityConverter()
    @Default(ParcourVisibility.private)
    ParcourVisibility parcourType,
    @Default([]) List<String> friendsToShare,
    @Default([]) List<UserModel> friends,
    UserModel? owner,
    String? title,
    String? description,
  }) = _UpdateParcourState;
}
