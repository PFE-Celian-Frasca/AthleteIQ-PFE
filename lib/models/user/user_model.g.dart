// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) => _$UserModelImpl(
      id: json['id'] as String,
      pseudo: json['pseudo'] as String,
      image: json['image'] as String? ??
          "https://w7.pngwing.com/pngs/177/551/png-transparent-user-interface-design-computer-icons-default-stephen-salazar-graphy-user-interface-design-computer-wallpaper-sphere-thumbnail.png",
      email: json['email'] as String,
      friends: (json['friends'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      sentFriendRequests:
          (json['sentFriendRequests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      receivedFriendRequests:
          (json['receivedFriendRequests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      fav: (json['fav'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      sex: json['sex'] as String,
      objectif: (json['objectif'] as num?)?.toDouble() ?? 5.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalDist: (json['totalDist'] as num?)?.toDouble() ?? 0.0,
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) => <String, dynamic>{
      'id': instance.id,
      'pseudo': instance.pseudo,
      'image': instance.image,
      'email': instance.email,
      'friends': instance.friends,
      'sentFriendRequests': instance.sentFriendRequests,
      'receivedFriendRequests': instance.receivedFriendRequests,
      'fav': instance.fav,
      'sex': instance.sex,
      'objectif': instance.objectif,
      'createdAt': instance.createdAt.toIso8601String(),
      'totalDist': instance.totalDist,
      'fcmToken': instance.fcmToken,
    };
