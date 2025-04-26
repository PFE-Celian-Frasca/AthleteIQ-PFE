import 'package:athlete_iq/enums/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_reply_model.freezed.dart';
part 'message_reply_model.g.dart';

@freezed
class MessageReplyModel with _$MessageReplyModel {
  const factory MessageReplyModel({
    required String message,
    required String senderUID,
    required String senderName,
    required String senderImage,
    required MessageEnum messageType,
    required bool isMe,
  }) = _MessageReplyModel;

  factory MessageReplyModel.fromJson(Map<String, dynamic> json) =>
      _$MessageReplyModelFromJson(json);
}
