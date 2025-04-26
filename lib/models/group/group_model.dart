import 'package:athlete_iq/enums/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    required String creatorUID,
    required String groupName,
    required String groupDescription,
    required String groupImage,
    required String groupId,
    required String lastMessage,
    required String senderUID,
    required MessageEnum messageType,
    required String messageId,
    @TimestampConverter() required DateTime timeSent,
    @TimestampConverter() required DateTime createdAt,
    required bool isPrivate,
    required bool editSettings,
    required List<String> membersUIDs,
    required List<String> adminsUIDs,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  static GroupModel empty() {
    return GroupModel(
      creatorUID: '',
      groupName: '',
      groupDescription: '',
      groupImage: '',
      groupId: '',
      lastMessage: '',
      senderUID: '',
      messageType: MessageEnum.text,
      messageId: '',
      timeSent: DateTime.now(),
      createdAt: DateTime.now(),
      isPrivate: true,
      editSettings: true,
      membersUIDs: [],
      adminsUIDs: [],
    );
  }
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
