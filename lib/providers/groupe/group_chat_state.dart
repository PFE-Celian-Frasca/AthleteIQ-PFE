import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_chat_state.freezed.dart';

@freezed
class GroupChatState with _$GroupChatState {
  const factory GroupChatState.initial() = _Initial;
  const factory GroupChatState.loading() = _Loading;
  const factory GroupChatState.loaded({
    required GroupModel groupDetails,
    required Stream<List<MessageModel>> messagesStream,
    required bool isSending,
  }) = _Loaded;
  const factory GroupChatState.error(String message) = _Error;
}
