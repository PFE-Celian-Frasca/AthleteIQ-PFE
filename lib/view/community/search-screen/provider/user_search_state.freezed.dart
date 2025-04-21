// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserSearchState {
  List<UserModel> get users => throw _privateConstructorUsedError;
  String? get query => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserSearchStateCopyWith<UserSearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSearchStateCopyWith<$Res> {
  factory $UserSearchStateCopyWith(
          UserSearchState value, $Res Function(UserSearchState) then) =
      _$UserSearchStateCopyWithImpl<$Res, UserSearchState>;
  @useResult
  $Res call(
      {List<UserModel> users,
      String? query,
      String? error,
      bool loading,
      bool hasMore});
}

/// @nodoc
class _$UserSearchStateCopyWithImpl<$Res, $Val extends UserSearchState>
    implements $UserSearchStateCopyWith<$Res> {
  _$UserSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? query = freezed,
    Object? error = freezed,
    Object? loading = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
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
abstract class _$$UserSearchStateImplCopyWith<$Res>
    implements $UserSearchStateCopyWith<$Res> {
  factory _$$UserSearchStateImplCopyWith(_$UserSearchStateImpl value,
          $Res Function(_$UserSearchStateImpl) then) =
      __$$UserSearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserModel> users,
      String? query,
      String? error,
      bool loading,
      bool hasMore});
}

/// @nodoc
class __$$UserSearchStateImplCopyWithImpl<$Res>
    extends _$UserSearchStateCopyWithImpl<$Res, _$UserSearchStateImpl>
    implements _$$UserSearchStateImplCopyWith<$Res> {
  __$$UserSearchStateImplCopyWithImpl(
      _$UserSearchStateImpl _value, $Res Function(_$UserSearchStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? query = freezed,
    Object? error = freezed,
    Object? loading = null,
    Object? hasMore = null,
  }) {
    return _then(_$UserSearchStateImpl(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
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

class _$UserSearchStateImpl implements _UserSearchState {
  const _$UserSearchStateImpl(
      {final List<UserModel> users = const [],
      this.query,
      this.error,
      this.loading = false,
      this.hasMore = true})
      : _users = users;

  final List<UserModel> _users;
  @override
  @JsonKey()
  List<UserModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
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
    return 'UserSearchState(users: $users, query: $query, error: $error, loading: $loading, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSearchStateImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_users),
      query,
      error,
      loading,
      hasMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSearchStateImplCopyWith<_$UserSearchStateImpl> get copyWith =>
      __$$UserSearchStateImplCopyWithImpl<_$UserSearchStateImpl>(
          this, _$identity);
}

abstract class _UserSearchState implements UserSearchState {
  const factory _UserSearchState(
      {final List<UserModel> users,
      final String? query,
      final String? error,
      final bool loading,
      final bool hasMore}) = _$UserSearchStateImpl;

  @override
  List<UserModel> get users;
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
  _$$UserSearchStateImplCopyWith<_$UserSearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
