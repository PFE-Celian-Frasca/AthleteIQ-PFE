import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'parcours_model.freezed.dart';
part 'parcours_model.g.dart';

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

class ParcourVisibilityConverter
    implements JsonConverter<ParcourVisibility, String> {
  const ParcourVisibilityConverter();

  @override
  ParcourVisibility fromJson(String json) => ParcourVisibility.values
      .firstWhere((e) => e.toString().split('.').last == json,
          orElse: () => ParcourVisibility.private);

  @override
  String toJson(ParcourVisibility object) => object.toString().split('.').last;
}

class SportTypeConverter implements JsonConverter<SportType, String> {
  const SportTypeConverter();

  @override
  SportType fromJson(String json) =>
      SportType.values.firstWhere((e) => e.toString().split('.').last == json,
          orElse: () => SportType.marche);

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
    required ParcourVisibility type,
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
