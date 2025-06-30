import 'package:athlete_iq/enums/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_message_model.freezed.dart';
part 'last_message_model.g.dart';

@freezed
class LastMessageModel with _$LastMessageModel {
  const factory LastMessageModel({
    required String senderUID,
    required String contactUID,
    required String contactName,
    required String contactImage,
    required String message,
    required MessageEnum messageType,
    required DateTime timeSent,
    required bool isSeen,
  }) = _LastMessageModel;

  factory LastMessageModel.fromJson(Map<String, dynamic> json) =>
      _$LastMessageModelFromJson(json);
}
