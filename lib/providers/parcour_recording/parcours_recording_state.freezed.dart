// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcours_recording_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ParcoursRecordingState {
  List<LocationData> get recordedLocations =>
      throw _privateConstructorUsedError;
  bool get isRecording => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ParcoursRecordingStateCopyWith<ParcoursRecordingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParcoursRecordingStateCopyWith<$Res> {
  factory $ParcoursRecordingStateCopyWith(ParcoursRecordingState value,
          $Res Function(ParcoursRecordingState) then) =
      _$ParcoursRecordingStateCopyWithImpl<$Res, ParcoursRecordingState>;
  @useResult
  $Res call({List<LocationData> recordedLocations, bool isRecording});
}

/// @nodoc
class _$ParcoursRecordingStateCopyWithImpl<$Res,
        $Val extends ParcoursRecordingState>
    implements $ParcoursRecordingStateCopyWith<$Res> {
  _$ParcoursRecordingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordedLocations = null,
    Object? isRecording = null,
  }) {
    return _then(_value.copyWith(
      recordedLocations: null == recordedLocations
          ? _value.recordedLocations
          : recordedLocations // ignore: cast_nullable_to_non_nullable
              as List<LocationData>,
      isRecording: null == isRecording
          ? _value.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParcoursRecordingStateImplCopyWith<$Res>
    implements $ParcoursRecordingStateCopyWith<$Res> {
  factory _$$ParcoursRecordingStateImplCopyWith(
          _$ParcoursRecordingStateImpl value,
          $Res Function(_$ParcoursRecordingStateImpl) then) =
      __$$ParcoursRecordingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LocationData> recordedLocations, bool isRecording});
}

/// @nodoc
class __$$ParcoursRecordingStateImplCopyWithImpl<$Res>
    extends _$ParcoursRecordingStateCopyWithImpl<$Res,
        _$ParcoursRecordingStateImpl>
    implements _$$ParcoursRecordingStateImplCopyWith<$Res> {
  __$$ParcoursRecordingStateImplCopyWithImpl(
      _$ParcoursRecordingStateImpl _value,
      $Res Function(_$ParcoursRecordingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordedLocations = null,
    Object? isRecording = null,
  }) {
    return _then(_$ParcoursRecordingStateImpl(
      recordedLocations: null == recordedLocations
          ? _value._recordedLocations
          : recordedLocations // ignore: cast_nullable_to_non_nullable
              as List<LocationData>,
      isRecording: null == isRecording
          ? _value.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ParcoursRecordingStateImpl implements _ParcoursRecordingState {
  const _$ParcoursRecordingStateImpl(
      {final List<LocationData> recordedLocations = const [],
      this.isRecording = false})
      : _recordedLocations = recordedLocations;

  final List<LocationData> _recordedLocations;
  @override
  @JsonKey()
  List<LocationData> get recordedLocations {
    if (_recordedLocations is EqualUnmodifiableListView)
      return _recordedLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recordedLocations);
  }

  @override
  @JsonKey()
  final bool isRecording;

  @override
  String toString() {
    return 'ParcoursRecordingState(recordedLocations: $recordedLocations, isRecording: $isRecording)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParcoursRecordingStateImpl &&
            const DeepCollectionEquality()
                .equals(other._recordedLocations, _recordedLocations) &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_recordedLocations), isRecording);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParcoursRecordingStateImplCopyWith<_$ParcoursRecordingStateImpl>
      get copyWith => __$$ParcoursRecordingStateImplCopyWithImpl<
          _$ParcoursRecordingStateImpl>(this, _$identity);
}

abstract class _ParcoursRecordingState implements ParcoursRecordingState {
  const factory _ParcoursRecordingState(
      {final List<LocationData> recordedLocations,
      final bool isRecording}) = _$ParcoursRecordingStateImpl;

  @override
  List<LocationData> get recordedLocations;
  @override
  bool get isRecording;
  @override
  @JsonKey(ignore: true)
  _$$ParcoursRecordingStateImplCopyWith<_$ParcoursRecordingStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
