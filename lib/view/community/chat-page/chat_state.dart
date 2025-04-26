import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:athlete_iq/models/message/message_reply_model.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(false) bool isLoading,
    MessageReplyModel? messageReplyModel,
  }) = _ChatState;
}
