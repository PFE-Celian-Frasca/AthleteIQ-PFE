import 'package:athlete_iq/enums/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String senderUID,
    required String senderName,
    required String senderImage,
    required String message,
    required MessageEnum messageType,
    @TimestampConverter() required DateTime timeSent,
    required String messageId,
    required bool isSeen,
    required String repliedMessage,
    required String repliedTo,
    required MessageEnum repliedMessageType,
    required List<String> reactions,
    required List<String> isSeenBy,
    required List<String> deletedBy,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
