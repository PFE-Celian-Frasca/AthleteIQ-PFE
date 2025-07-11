// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_timer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomTimer _$CustomTimerFromJson(Map<String, dynamic> json) {
  return _CustomTimer.fromJson(json);
}

/// @nodoc
mixin _$CustomTimer {
  int get hours => throw _privateConstructorUsedError;
  int get minutes => throw _privateConstructorUsedError;
  int get seconds => throw _privateConstructorUsedError;

  /// Serializes this CustomTimer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomTimer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomTimerCopyWith<CustomTimer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomTimerCopyWith<$Res> {
  factory $CustomTimerCopyWith(CustomTimer value, $Res Function(CustomTimer) then) =
      _$CustomTimerCopyWithImpl<$Res, CustomTimer>;
  @useResult
  $Res call({int hours, int minutes, int seconds});
}

/// @nodoc
class _$CustomTimerCopyWithImpl<$Res, $Val extends CustomTimer>
    implements $CustomTimerCopyWith<$Res> {
  _$CustomTimerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomTimer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hours = null,
    Object? minutes = null,
    Object? seconds = null,
  }) {
    return _then(_value.copyWith(
      hours: null == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as int,
      minutes: null == minutes
          ? _value.minutes
          : minutes // ignore: cast_nullable_to_non_nullable
              as int,
      seconds: null == seconds
          ? _value.seconds
          : seconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomTimerImplCopyWith<$Res> implements $CustomTimerCopyWith<$Res> {
  factory _$$CustomTimerImplCopyWith(
          _$CustomTimerImpl value, $Res Function(_$CustomTimerImpl) then) =
      __$$CustomTimerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hours, int minutes, int seconds});
}

/// @nodoc
class __$$CustomTimerImplCopyWithImpl<$Res>
    extends _$CustomTimerCopyWithImpl<$Res, _$CustomTimerImpl>
    implements _$$CustomTimerImplCopyWith<$Res> {
  __$$CustomTimerImplCopyWithImpl(_$CustomTimerImpl _value, $Res Function(_$CustomTimerImpl) _then)
      : super(_value, _then);

  /// Create a copy of CustomTimer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hours = null,
    Object? minutes = null,
    Object? seconds = null,
  }) {
    return _then(_$CustomTimerImpl(
      hours: null == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as int,
      minutes: null == minutes
          ? _value.minutes
          : minutes // ignore: cast_nullable_to_non_nullable
              as int,
      seconds: null == seconds
          ? _value.seconds
          : seconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomTimerImpl implements _CustomTimer {
  const _$CustomTimerImpl({this.hours = 0, this.minutes = 0, this.seconds = 0});

  factory _$CustomTimerImpl.fromJson(Map<String, dynamic> json) => _$$CustomTimerImplFromJson(json);

  @override
  @JsonKey()
  final int hours;
  @override
  @JsonKey()
  final int minutes;
  @override
  @JsonKey()
  final int seconds;

  @override
  String toString() {
    return 'CustomTimer(hours: $hours, minutes: $minutes, seconds: $seconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomTimerImpl &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.minutes, minutes) || other.minutes == minutes) &&
            (identical(other.seconds, seconds) || other.seconds == seconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hours, minutes, seconds);

  /// Create a copy of CustomTimer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomTimerImplCopyWith<_$CustomTimerImpl> get copyWith =>
      __$$CustomTimerImplCopyWithImpl<_$CustomTimerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomTimerImplToJson(
      this,
    );
  }
}

abstract class _CustomTimer implements CustomTimer {
  const factory _CustomTimer({final int hours, final int minutes, final int seconds}) =
      _$CustomTimerImpl;

  factory _CustomTimer.fromJson(Map<String, dynamic> json) = _$CustomTimerImpl.fromJson;

  @override
  int get hours;
  @override
  int get minutes;
  @override
  int get seconds;

  /// Create a copy of CustomTimer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomTimerImplCopyWith<_$CustomTimerImpl> get copyWith => throw _privateConstructorUsedError;
}
