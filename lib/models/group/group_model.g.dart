// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupModelImpl _$$GroupModelImplFromJson(Map<String, dynamic> json) =>
    _$GroupModelImpl(
      id: json['id'] as String?,
      admin: json['admin'] as String,
      groupName: json['groupName'] as String,
      groupIcon: json['groupIcon'] as String?,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      type: json['type'] as String? ?? 'public',
      recentMessage: json['recentMessage'] as String? ?? '',
      recentMessageSender: json['recentMessageSender'] as String?,
      recentMessageTime: json['recentMessageTime'] == null
          ? null
          : DateTime.parse(json['recentMessageTime'] as String),
    );

Map<String, dynamic> _$$GroupModelImplToJson(_$GroupModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'admin': instance.admin,
      'groupName': instance.groupName,
      'groupIcon': instance.groupIcon,
      'members': instance.members,
      'type': instance.type,
      'recentMessage': instance.recentMessage,
      'recentMessageSender': instance.recentMessageSender,
      'recentMessageTime': instance.recentMessageTime?.toIso8601String(),
    };
