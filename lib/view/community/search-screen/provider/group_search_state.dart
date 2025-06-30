import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlete_iq/models/group/group_model.dart';

part 'group_search_state.freezed.dart';

@freezed
class GroupSearchState with _$GroupSearchState {
  const factory GroupSearchState({
    @Default([]) List<GroupModel> allGroups,
    @Default([]) List<GroupModel> filteredGroups,
    @Default(false) bool loading,
    String? error,
  }) = _GroupSearchState;
}
