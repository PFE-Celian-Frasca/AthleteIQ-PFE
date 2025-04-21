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
  List<GroupModel> get groups => throw _privateConstructorUsedError;
  String? get query => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      {List<GroupModel> groups,
      String? query,
      String? error,
      bool loading,
      bool hasMore});
}

/// @nodoc
class _$GroupSearchStateCopyWithImpl<$Res, $Val extends GroupSearchState>
    implements $GroupSearchStateCopyWith<$Res> {
  _$GroupSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groups = null,
    Object? query = freezed,
    Object? error = freezed,
    Object? loading = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      groups: null == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<GroupModel>,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
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
      {List<GroupModel> groups,
      String? query,
      String? error,
      bool loading,
      bool hasMore});
}

/// @nodoc
class __$$GroupSearchStateImplCopyWithImpl<$Res>
    extends _$GroupSearchStateCopyWithImpl<$Res, _$GroupSearchStateImpl>
    implements _$$GroupSearchStateImplCopyWith<$Res> {
  __$$GroupSearchStateImplCopyWithImpl(_$GroupSearchStateImpl _value,
      $Res Function(_$GroupSearchStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groups = null,
    Object? query = freezed,
    Object? error = freezed,
    Object? loading = null,
    Object? hasMore = null,
  }) {
    return _then(_$GroupSearchStateImpl(
      groups: null == groups
          ? _value._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<GroupModel>,
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$GroupSearchStateImpl implements _GroupSearchState {
  const _$GroupSearchStateImpl(
      {final List<GroupModel> groups = const [],
      this.query,
      this.error,
      this.loading = false,
      this.hasMore = true})
      : _groups = groups;

  final List<GroupModel> _groups;
  @override
  @JsonKey()
  List<GroupModel> get groups {
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groups);
  }

  @override
  final String? query;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool hasMore;

  @override
  String toString() {
    return 'GroupSearchState(groups: $groups, query: $query, error: $error, loading: $loading, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupSearchStateImpl &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_groups),
      query,
      error,
      loading,
      hasMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupSearchStateImplCopyWith<_$GroupSearchStateImpl> get copyWith =>
      __$$GroupSearchStateImplCopyWithImpl<_$GroupSearchStateImpl>(
          this, _$identity);
}

abstract class _GroupSearchState implements GroupSearchState {
  const factory _GroupSearchState(
      {final List<GroupModel> groups,
      final String? query,
      final String? error,
      final bool loading,
      final bool hasMore}) = _$GroupSearchStateImpl;

  @override
  List<GroupModel> get groups;
  @override
  String? get query;
  @override
  String? get error;
  @override
  bool get loading;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$GroupSearchStateImplCopyWith<_$GroupSearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
