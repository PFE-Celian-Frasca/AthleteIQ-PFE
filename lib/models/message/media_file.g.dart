// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaFileImpl _$$MediaFileImplFromJson(Map<String, dynamic> json) =>
    _$MediaFileImpl(
      url: json['url'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$$MediaFileImplToJson(_$MediaFileImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'mimeType': instance.mimeType,
      'size': instance.size,
    };
