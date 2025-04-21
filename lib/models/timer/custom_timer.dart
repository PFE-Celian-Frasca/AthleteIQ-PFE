import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_timer.freezed.dart';
part 'custom_timer.g.dart';

@freezed
class CustomTimer with _$CustomTimer {
  const factory CustomTimer({
    @Default(0) int hours,
    @Default(0) int minutes,
    @Default(0) int seconds,
  }) = _CustomTimer;

  factory CustomTimer.fromJson(Map<String, dynamic> json) =>
      _$CustomTimerFromJson(json);
}

class CustomTimerConverter
    implements JsonConverter<CustomTimer, Map<String, dynamic>> {
  const CustomTimerConverter();

  @override
  CustomTimer fromJson(Map<String, dynamic> json) {
    return CustomTimer(
      hours: json['hours'] as int,
      minutes: json['minutes'] as int,
      seconds: json['seconds'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson(CustomTimer timer) {
    return {
      'hours': timer.hours,
      'minutes': timer.minutes,
      'seconds': timer.seconds,
    };
  }
}
