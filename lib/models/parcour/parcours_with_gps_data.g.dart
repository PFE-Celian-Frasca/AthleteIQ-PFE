// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcours_with_gps_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParcoursWithGPSDataImpl _$$ParcoursWithGPSDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ParcoursWithGPSDataImpl(
      parcours:
          ParcoursModel.fromJson(json['parcours'] as Map<String, dynamic>),
      gpsData: (json['gpsData'] as List<dynamic>)
          .map((e) => LocationDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ParcoursWithGPSDataImplToJson(
        _$ParcoursWithGPSDataImpl instance) =>
    <String, dynamic>{
      'parcours': instance.parcours,
      'gpsData': instance.gpsData,
    };
