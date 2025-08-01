// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPreferencesModelImpl _$$UserPreferencesModelImplFromJson(Map<String, dynamic> json) =>
    _$UserPreferencesModelImpl(
      receiveNotifications: json['receiveNotifications'] as bool? ?? true,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? '',
    );

Map<String, dynamic> _$$UserPreferencesModelImplToJson(_$UserPreferencesModelImpl instance) =>
    <String, dynamic>{
      'receiveNotifications': instance.receiveNotifications,
      'darkModeEnabled': instance.darkModeEnabled,
      'language': instance.language,
    };
