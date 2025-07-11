// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cluster_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClusterState {
  Set<Marker> get markers => throw _privateConstructorUsedError;
  Set<Polyline> get polylines => throw _privateConstructorUsedError;
  bool? get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ClusterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClusterStateCopyWith<ClusterState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClusterStateCopyWith<$Res> {
  factory $ClusterStateCopyWith(ClusterState value, $Res Function(ClusterState) then) =
      _$ClusterStateCopyWithImpl<$Res, ClusterState>;
  @useResult
  $Res call({Set<Marker> markers, Set<Polyline> polylines, bool? isLoading, String? error});
}

/// @nodoc
class _$ClusterStateCopyWithImpl<$Res, $Val extends ClusterState>
    implements $ClusterStateCopyWith<$Res> {
  _$ClusterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClusterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? markers = null,
    Object? polylines = null,
    Object? isLoading = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      markers: null == markers
          ? _value.markers
          : markers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      polylines: null == polylines
          ? _value.polylines
          : polylines // ignore: cast_nullable_to_non_nullable
              as Set<Polyline>,
      isLoading: freezed == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClusterStateImplCopyWith<$Res> implements $ClusterStateCopyWith<$Res> {
  factory _$$ClusterStateImplCopyWith(
          _$ClusterStateImpl value, $Res Function(_$ClusterStateImpl) then) =
      __$$ClusterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<Marker> markers, Set<Polyline> polylines, bool? isLoading, String? error});
}

/// @nodoc
class __$$ClusterStateImplCopyWithImpl<$Res>
    extends _$ClusterStateCopyWithImpl<$Res, _$ClusterStateImpl>
    implements _$$ClusterStateImplCopyWith<$Res> {
  __$$ClusterStateImplCopyWithImpl(
      _$ClusterStateImpl _value, $Res Function(_$ClusterStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClusterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? markers = null,
    Object? polylines = null,
    Object? isLoading = freezed,
    Object? error = freezed,
  }) {
    return _then(_$ClusterStateImpl(
      markers: null == markers
          ? _value._markers
          : markers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      polylines: null == polylines
          ? _value._polylines
          : polylines // ignore: cast_nullable_to_non_nullable
              as Set<Polyline>,
      isLoading: freezed == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ClusterStateImpl implements _ClusterState {
  const _$ClusterStateImpl(
      {final Set<Marker> markers = const <Marker>{},
      final Set<Polyline> polylines = const <Polyline>{},
      this.isLoading,
      this.error})
      : _markers = markers,
        _polylines = polylines;

  final Set<Marker> _markers;
  @override
  @JsonKey()
  Set<Marker> get markers {
    if (_markers is EqualUnmodifiableSetView) return _markers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_markers);
  }

  final Set<Polyline> _polylines;
  @override
  @JsonKey()
  Set<Polyline> get polylines {
    if (_polylines is EqualUnmodifiableSetView) return _polylines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_polylines);
  }

  @override
  final bool? isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'ClusterState(markers: $markers, polylines: $polylines, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClusterStateImpl &&
            const DeepCollectionEquality().equals(other._markers, _markers) &&
            const DeepCollectionEquality().equals(other._polylines, _polylines) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_markers),
      const DeepCollectionEquality().hash(_polylines), isLoading, error);

  /// Create a copy of ClusterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClusterStateImplCopyWith<_$ClusterStateImpl> get copyWith =>
      __$$ClusterStateImplCopyWithImpl<_$ClusterStateImpl>(this, _$identity);
}

abstract class _ClusterState implements ClusterState {
  const factory _ClusterState(
      {final Set<Marker> markers,
      final Set<Polyline> polylines,
      final bool? isLoading,
      final String? error}) = _$ClusterStateImpl;

  @override
  Set<Marker> get markers;
  @override
  Set<Polyline> get polylines;
  @override
  bool? get isLoading;
  @override
  String? get error;

  /// Create a copy of ClusterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClusterStateImplCopyWith<_$ClusterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
