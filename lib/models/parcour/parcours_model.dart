import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'parcours_model.freezed.dart';
part 'parcours_model.g.dart';

enum ParcoursType { Private, Public, Shared }

enum SportType { Marche, Course, Velo, Natation }

class DateTimeTimestampConverter implements JsonConverter<DateTime, dynamic> {
  const DateTimeTimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    }
    throw Exception('Expected Timestamp or String, got ${json.runtimeType}');
  }

  @override
  dynamic toJson(DateTime object) => object;
}

class ParcoursTypeConverter implements JsonConverter<ParcoursType, String> {
  const ParcoursTypeConverter();

  @override
  ParcoursType fromJson(String json) => ParcoursType.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => ParcoursType.Private);

  @override
  String toJson(ParcoursType object) => object.toString().split('.').last;
}

class SportTypeConverter implements JsonConverter<SportType, String> {
  const SportTypeConverter();

  @override
  SportType fromJson(String json) =>
      SportType.values.firstWhere((e) => e.toString().split('.').last == json,
          orElse: () => SportType.Marche);

  @override
  String toJson(SportType object) => object.toString().split('.').last;
}

@freezed
class ParcoursModel with _$ParcoursModel {
  const factory ParcoursModel({
    String? id,
    required String owner,
    required String title,
    String? description,
    required ParcoursType type,
    required SportType sportType,
    required List<String> shareTo,
    @CustomTimerConverter() required CustomTimer timer,
    required DateTime createdAt,
    required double vm,
    required double totalDistance,
    String? parcoursDataUrl,
  }) = _ParcoursModel;

  factory ParcoursModel.fromJson(Map<String, dynamic> json) =>
      _$ParcoursModelFromJson(json);
}
