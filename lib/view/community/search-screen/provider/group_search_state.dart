import 'package:athlete_iq/models/group/group_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_search_state.freezed.dart';

@freezed
class GroupSearchState with _$GroupSearchState {
  const factory GroupSearchState({
    @Default([]) List<GroupModel> groups,
    String? query,
    String? error,
    @Default(false) bool loading,
    @Default(true) bool hasMore,
  }) = _GroupSearchState;

  // Factory constructor for initializing with default values
  factory GroupSearchState.initial() => const GroupSearchState();
}
