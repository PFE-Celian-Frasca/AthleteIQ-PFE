// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GroupSearchState {
  List<GroupModel> get allGroups => throw _privateConstructorUsedError;
  List<GroupModel> get filteredGroups => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of GroupSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupSearchStateCopyWith<GroupSearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupSearchStateCopyWith<$Res> {
  factory $GroupSearchStateCopyWith(
          GroupSearchState value, $Res Function(GroupSearchState) then) =
      _$GroupSearchStateCopyWithImpl<$Res, GroupSearchState>;
  @useResult
  $Res call(
      {List<GroupModel> allGroups,
      List<GroupModel> filteredGroups,
      bool loading,
      String? error});
}

/// @nodoc
class _$GroupSearchStateCopyWithImpl<$Res, $Val extends GroupSearchState>
    implements $GroupSearchStateCopyWith<$Res> {
  _$GroupSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allGroups = null,
    Object? filteredGroups = null,
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      allGroups: null == allGroups
          ? _value.allGroups
          : allGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupModel>,
      filteredGroups: null == filteredGroups
          ? _value.filteredGroups
          : filteredGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupModel>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupSearchStateImplCopyWith<$Res>
    implements $GroupSearchStateCopyWith<$Res> {
  factory _$$GroupSearchStateImplCopyWith(_$GroupSearchStateImpl value,
          $Res Function(_$GroupSearchStateImpl) then) =
      __$$GroupSearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<GroupModel> allGroups,
      List<GroupModel> filteredGroups,
      bool loading,
      String? error});
}

/// @nodoc
class __$$GroupSearchStateImplCopyWithImpl<$Res>
    extends _$GroupSearchStateCopyWithImpl<$Res, _$GroupSearchStateImpl>
    implements _$$GroupSearchStateImplCopyWith<$Res> {
  __$$GroupSearchStateImplCopyWithImpl(_$GroupSearchStateImpl _value,
      $Res Function(_$GroupSearchStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allGroups = null,
    Object? filteredGroups = null,
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(_$GroupSearchStateImpl(
      allGroups: null == allGroups
          ? _value._allGroups
          : allGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupModel>,
      filteredGroups: null == filteredGroups
          ? _value._filteredGroups
          : filteredGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupModel>,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GroupSearchStateImpl implements _GroupSearchState {
  const _$GroupSearchStateImpl(
      {final List<GroupModel> allGroups = const [],
      final List<GroupModel> filteredGroups = const [],
      this.loading = false,
      this.error})
      : _allGroups = allGroups,
        _filteredGroups = filteredGroups;

  final List<GroupModel> _allGroups;
  @override
  @JsonKey()
  List<GroupModel> get allGroups {
    if (_allGroups is EqualUnmodifiableListView) return _allGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allGroups);
  }

  final List<GroupModel> _filteredGroups;
  @override
  @JsonKey()
  List<GroupModel> get filteredGroups {
    if (_filteredGroups is EqualUnmodifiableListView) return _filteredGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredGroups);
  }

  @override
  @JsonKey()
  final bool loading;
  @override
  final String? error;

  @override
  String toString() {
    return 'GroupSearchState(allGroups: $allGroups, filteredGroups: $filteredGroups, loading: $loading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupSearchStateImpl &&
            const DeepCollectionEquality()
                .equals(other._allGroups, _allGroups) &&
            const DeepCollectionEquality()
                .equals(other._filteredGroups, _filteredGroups) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allGroups),
      const DeepCollectionEquality().hash(_filteredGroups),
      loading,
      error);

  /// Create a copy of GroupSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupSearchStateImplCopyWith<_$GroupSearchStateImpl> get copyWith =>
      __$$GroupSearchStateImplCopyWithImpl<_$GroupSearchStateImpl>(
          this, _$identity);
}

abstract class _GroupSearchState implements GroupSearchState {
  const factory _GroupSearchState(
      {final List<GroupModel> allGroups,
      final List<GroupModel> filteredGroups,
      final bool loading,
      final String? error}) = _$GroupSearchStateImpl;

  @override
  List<GroupModel> get allGroups;
  @override
  List<GroupModel> get filteredGroups;
  @override
  bool get loading;
  @override
  String? get error;

  /// Create a copy of GroupSearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupSearchStateImplCopyWith<_$GroupSearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
