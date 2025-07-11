// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LastMessageModelImpl _$$LastMessageModelImplFromJson(Map<String, dynamic> json) =>
    _$LastMessageModelImpl(
      senderUID: json['senderUID'] as String,
      contactUID: json['contactUID'] as String,
      contactName: json['contactName'] as String,
      contactImage: json['contactImage'] as String,
      message: json['message'] as String,
      messageType: $enumDecode(_$MessageEnumEnumMap, json['messageType']),
      timeSent: DateTime.parse(json['timeSent'] as String),
      isSeen: json['isSeen'] as bool,
    );

Map<String, dynamic> _$$LastMessageModelImplToJson(_$LastMessageModelImpl instance) =>
    <String, dynamic>{
      'senderUID': instance.senderUID,
      'contactUID': instance.contactUID,
      'contactName': instance.contactName,
      'contactImage': instance.contactImage,
      'message': instance.message,
      'messageType': _$MessageEnumEnumMap[instance.messageType]!,
      'timeSent': instance.timeSent.toIso8601String(),
      'isSeen': instance.isSeen,
    };

const _$MessageEnumEnumMap = {
  MessageEnum.text: 'text',
  MessageEnum.image: 'image',
  MessageEnum.video: 'video',
  MessageEnum.audio: 'audio',
};
