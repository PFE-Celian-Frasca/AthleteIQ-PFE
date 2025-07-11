// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcours_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParcoursModelImpl _$$ParcoursModelImplFromJson(Map<String, dynamic> json) => _$ParcoursModelImpl(
      id: json['id'] as String?,
      owner: json['owner'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$ParcourVisibilityEnumMap, json['type']),
      sportType: $enumDecode(_$SportTypeEnumMap, json['sportType']),
      shareTo: (json['shareTo'] as List<dynamic>).map((e) => e as String).toList(),
      timer: const CustomTimerConverter().fromJson(json['timer'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      vm: (json['vm'] as num).toDouble(),
      totalDistance: (json['totalDistance'] as num).toDouble(),
      parcoursDataUrl: json['parcoursDataUrl'] as String?,
    );

Map<String, dynamic> _$$ParcoursModelImplToJson(_$ParcoursModelImpl instance) => <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'title': instance.title,
      'description': instance.description,
      'type': _$ParcourVisibilityEnumMap[instance.type]!,
      'sportType': _$SportTypeEnumMap[instance.sportType]!,
      'shareTo': instance.shareTo,
      'timer': const CustomTimerConverter().toJson(instance.timer),
      'createdAt': instance.createdAt.toIso8601String(),
      'vm': instance.vm,
      'totalDistance': instance.totalDistance,
      'parcoursDataUrl': instance.parcoursDataUrl,
    };

const _$ParcourVisibilityEnumMap = {
  ParcourVisibility.public: 'public',
  ParcourVisibility.private: 'private',
  ParcourVisibility.shared: 'shared',
};

const _$SportTypeEnumMap = {
  SportType.marche: 'marche',
  SportType.course: 'course',
  SportType.velo: 'velo',
  SportType.natation: 'natation',
};
