// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) => _$MessageModelImpl(
      senderUID: json['senderUID'] as String,
      senderName: json['senderName'] as String,
      senderImage: json['senderImage'] as String,
      message: json['message'] as String,
      messageType: $enumDecode(_$MessageEnumEnumMap, json['messageType']),
      timeSent: const TimestampConverter().fromJson(json['timeSent'] as Timestamp),
      messageId: json['messageId'] as String,
      isSeen: json['isSeen'] as bool,
      repliedMessage: json['repliedMessage'] as String,
      repliedTo: json['repliedTo'] as String,
      repliedMessageType: $enumDecode(_$MessageEnumEnumMap, json['repliedMessageType']),
      reactions: (json['reactions'] as List<dynamic>).map((e) => e as String).toList(),
      isSeenBy: (json['isSeenBy'] as List<dynamic>).map((e) => e as String).toList(),
      deletedBy: (json['deletedBy'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) => <String, dynamic>{
      'senderUID': instance.senderUID,
      'senderName': instance.senderName,
      'senderImage': instance.senderImage,
      'message': instance.message,
      'messageType': _$MessageEnumEnumMap[instance.messageType]!,
      'timeSent': const TimestampConverter().toJson(instance.timeSent),
      'messageId': instance.messageId,
      'isSeen': instance.isSeen,
      'repliedMessage': instance.repliedMessage,
      'repliedTo': instance.repliedTo,
      'repliedMessageType': _$MessageEnumEnumMap[instance.repliedMessageType]!,
      'reactions': instance.reactions,
      'isSeenBy': instance.isSeenBy,
      'deletedBy': instance.deletedBy,
    };

const _$MessageEnumEnumMap = {
  MessageEnum.text: 'text',
  MessageEnum.image: 'image',
  MessageEnum.video: 'video',
};
