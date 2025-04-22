// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationDataModelImpl _$$LocationDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationDataModelImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      speedAccuracy: (json['speedAccuracy'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      time: (json['time'] as num?)?.toDouble(),
      verticalAccuracy: (json['verticalAccuracy'] as num?)?.toDouble(),
      headingAccuracy: (json['headingAccuracy'] as num?)?.toDouble(),
      elapsedRealtimeNanos: (json['elapsedRealtimeNanos'] as num?)?.toDouble(),
      elapsedRealtimeUncertaintyNanos:
          (json['elapsedRealtimeUncertaintyNanos'] as num?)?.toDouble(),
      satelliteNumber: (json['satelliteNumber'] as num?)?.toInt(),
      provider: json['provider'] as String?,
    );

Map<String, dynamic> _$$LocationDataModelImplToJson(
        _$LocationDataModelImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'altitude': instance.altitude,
      'speed': instance.speed,
      'speedAccuracy': instance.speedAccuracy,
      'heading': instance.heading,
      'time': instance.time,
      'verticalAccuracy': instance.verticalAccuracy,
      'headingAccuracy': instance.headingAccuracy,
      'elapsedRealtimeNanos': instance.elapsedRealtimeNanos,
      'elapsedRealtimeUncertaintyNanos':
          instance.elapsedRealtimeUncertaintyNanos,
      'satelliteNumber': instance.satelliteNumber,
      'provider': instance.provider,
    };
