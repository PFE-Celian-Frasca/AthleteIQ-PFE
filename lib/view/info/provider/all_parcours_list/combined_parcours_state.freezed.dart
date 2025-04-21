// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combined_parcours_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CombinedParcoursState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<ParcoursWithGPSData>? get loadedParcours =>
      throw _privateConstructorUsedError;
  List<ParcoursWithGPSData>? get favoritesParcours =>
      throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CombinedParcoursStateCopyWith<CombinedParcoursState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CombinedParcoursStateCopyWith<$Res> {
  factory $CombinedParcoursStateCopyWith(CombinedParcoursState value,
          $Res Function(CombinedParcoursState) then) =
      _$CombinedParcoursStateCopyWithImpl<$Res, CombinedParcoursState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<ParcoursWithGPSData>? loadedParcours,
      List<ParcoursWithGPSData>? favoritesParcours,
      String? error});
}

/// @nodoc
class _$CombinedParcoursStateCopyWithImpl<$Res,
        $Val extends CombinedParcoursState>
    implements $CombinedParcoursStateCopyWith<$Res> {
  _$CombinedParcoursStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? loadedParcours = freezed,
    Object? favoritesParcours = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadedParcours: freezed == loadedParcours
          ? _value.loadedParcours
          : loadedParcours // ignore: cast_nullable_to_non_nullable
              as List<ParcoursWithGPSData>?,
      favoritesParcours: freezed == favoritesParcours
          ? _value.favoritesParcours
          : favoritesParcours // ignore: cast_nullable_to_non_nullable
              as List<ParcoursWithGPSData>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CombinedParcoursStateImplCopyWith<$Res>
    implements $CombinedParcoursStateCopyWith<$Res> {
  factory _$$CombinedParcoursStateImplCopyWith(
          _$CombinedParcoursStateImpl value,
          $Res Function(_$CombinedParcoursStateImpl) then) =
      __$$CombinedParcoursStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<ParcoursWithGPSData>? loadedParcours,
      List<ParcoursWithGPSData>? favoritesParcours,
      String? error});
}

/// @nodoc
class __$$CombinedParcoursStateImplCopyWithImpl<$Res>
    extends _$CombinedParcoursStateCopyWithImpl<$Res,
        _$CombinedParcoursStateImpl>
    implements _$$CombinedParcoursStateImplCopyWith<$Res> {
  __$$CombinedParcoursStateImplCopyWithImpl(_$CombinedParcoursStateImpl _value,
      $Res Function(_$CombinedParcoursStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? loadedParcours = freezed,
    Object? favoritesParcours = freezed,
    Object? error = freezed,
  }) {
    return _then(_$CombinedParcoursStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadedParcours: freezed == loadedParcours
          ? _value._loadedParcours
          : loadedParcours // ignore: cast_nullable_to_non_nullable
              as List<ParcoursWithGPSData>?,
      favoritesParcours: freezed == favoritesParcours
          ? _value._favoritesParcours
          : favoritesParcours // ignore: cast_nullable_to_non_nullable
              as List<ParcoursWithGPSData>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CombinedParcoursStateImpl implements _CombinedParcoursState {
  const _$CombinedParcoursStateImpl(
      {this.isLoading = false,
      final List<ParcoursWithGPSData>? loadedParcours,
      final List<ParcoursWithGPSData>? favoritesParcours,
      this.error})
      : _loadedParcours = loadedParcours,
        _favoritesParcours = favoritesParcours;

  @override
  @JsonKey()
  final bool isLoading;
  final List<ParcoursWithGPSData>? _loadedParcours;
  @override
  List<ParcoursWithGPSData>? get loadedParcours {
    final value = _loadedParcours;
    if (value == null) return null;
    if (_loadedParcours is EqualUnmodifiableListView) return _loadedParcours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ParcoursWithGPSData>? _favoritesParcours;
  @override
  List<ParcoursWithGPSData>? get favoritesParcours {
    final value = _favoritesParcours;
    if (value == null) return null;
    if (_favoritesParcours is EqualUnmodifiableListView)
      return _favoritesParcours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'CombinedParcoursState(isLoading: $isLoading, loadedParcours: $loadedParcours, favoritesParcours: $favoritesParcours, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CombinedParcoursStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._loadedParcours, _loadedParcours) &&
            const DeepCollectionEquality()
                .equals(other._favoritesParcours, _favoritesParcours) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_loadedParcours),
      const DeepCollectionEquality().hash(_favoritesParcours),
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CombinedParcoursStateImplCopyWith<_$CombinedParcoursStateImpl>
      get copyWith => __$$CombinedParcoursStateImplCopyWithImpl<
          _$CombinedParcoursStateImpl>(this, _$identity);
}

abstract class _CombinedParcoursState implements CombinedParcoursState {
  const factory _CombinedParcoursState(
      {final bool isLoading,
      final List<ParcoursWithGPSData>? loadedParcours,
      final List<ParcoursWithGPSData>? favoritesParcours,
      final String? error}) = _$CombinedParcoursStateImpl;

  @override
  bool get isLoading;
  @override
  List<ParcoursWithGPSData>? get loadedParcours;
  @override
  List<ParcoursWithGPSData>? get favoritesParcours;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$CombinedParcoursStateImplCopyWith<_$CombinedParcoursStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
