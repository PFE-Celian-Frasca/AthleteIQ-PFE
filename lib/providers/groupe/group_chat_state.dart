import 'package:athlete_iq/models/group/group_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_chat_state.freezed.dart';

@freezed
class GroupChatState with _$GroupChatState {
  const factory GroupChatState({
    required GroupModel groupDetails,
    required bool isLoading,
    required String? error,
  }) = _GroupChatState;
}
