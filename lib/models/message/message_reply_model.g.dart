// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageReplyModelImpl _$$MessageReplyModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageReplyModelImpl(
      message: json['message'] as String,
      senderUID: json['senderUID'] as String,
      senderName: json['senderName'] as String,
      senderImage: json['senderImage'] as String,
      messageType: $enumDecode(_$MessageEnumEnumMap, json['messageType']),
      isMe: json['isMe'] as bool,
    );

Map<String, dynamic> _$$MessageReplyModelImplToJson(_$MessageReplyModelImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'senderUID': instance.senderUID,
      'senderName': instance.senderName,
      'senderImage': instance.senderImage,
      'messageType': _$MessageEnumEnumMap[instance.messageType]!,
      'isMe': instance.isMe,
    };

const _$MessageEnumEnumMap = {
  MessageEnum.text: 'text',
  MessageEnum.image: 'image',
  MessageEnum.video: 'video',
  MessageEnum.audio: 'audio',
};
