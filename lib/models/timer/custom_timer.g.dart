// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomTimerImpl _$$CustomTimerImplFromJson(Map<String, dynamic> json) => _$CustomTimerImpl(
      hours: (json['hours'] as num?)?.toInt() ?? 0,
      minutes: (json['minutes'] as num?)?.toInt() ?? 0,
      seconds: (json['seconds'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CustomTimerImplToJson(_$CustomTimerImpl instance) => <String, dynamic>{
      'hours': instance.hours,
      'minutes': instance.minutes,
      'seconds': instance.seconds,
    };
