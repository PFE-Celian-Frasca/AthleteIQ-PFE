// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupModelImpl _$$GroupModelImplFromJson(Map<String, dynamic> json) =>
    _$GroupModelImpl(
      creatorUID: json['creatorUID'] as String,
      groupName: json['groupName'] as String,
      groupDescription: json['groupDescription'] as String,
      groupImage: json['groupImage'] as String,
      groupId: json['groupId'] as String,
      lastMessage: json['lastMessage'] as String,
      senderUID: json['senderUID'] as String,
      messageType: $enumDecode(_$MessageEnumEnumMap, json['messageType']),
      messageId: json['messageId'] as String,
      timeSent:
          const TimestampConverter().fromJson(json['timeSent'] as Timestamp),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      isPrivate: json['isPrivate'] as bool,
      editSettings: json['editSettings'] as bool,
      membersUIDs: (json['membersUIDs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      adminsUIDs: (json['adminsUIDs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$GroupModelImplToJson(_$GroupModelImpl instance) =>
    <String, dynamic>{
      'creatorUID': instance.creatorUID,
      'groupName': instance.groupName,
      'groupDescription': instance.groupDescription,
      'groupImage': instance.groupImage,
      'groupId': instance.groupId,
      'lastMessage': instance.lastMessage,
      'senderUID': instance.senderUID,
      'messageType': _$MessageEnumEnumMap[instance.messageType]!,
      'messageId': instance.messageId,
      'timeSent': const TimestampConverter().toJson(instance.timeSent),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'isPrivate': instance.isPrivate,
      'editSettings': instance.editSettings,
      'membersUIDs': instance.membersUIDs,
      'adminsUIDs': instance.adminsUIDs,
    };

const _$MessageEnumEnumMap = {
  MessageEnum.text: 'text',
  MessageEnum.image: 'image',
  MessageEnum.video: 'video',
  MessageEnum.audio: 'audio',
};
