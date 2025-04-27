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
  List<UserModel> get allUsers => throw _privateConstructorUsedError;
  List<UserModel> get filteredUsers => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of UserSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {List<UserModel> allUsers,
      List<UserModel> filteredUsers,
      bool loading,
      String? error});
}

/// @nodoc
class _$UserSearchStateCopyWithImpl<$Res, $Val extends UserSearchState>
    implements $UserSearchStateCopyWith<$Res> {
  _$UserSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allUsers = null,
    Object? filteredUsers = null,
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      allUsers: null == allUsers
          ? _value.allUsers
          : allUsers // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      filteredUsers: null == filteredUsers
          ? _value.filteredUsers
          : filteredUsers // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
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
abstract class _$$UserSearchStateImplCopyWith<$Res>
    implements $UserSearchStateCopyWith<$Res> {
  factory _$$UserSearchStateImplCopyWith(_$UserSearchStateImpl value,
          $Res Function(_$UserSearchStateImpl) then) =
      __$$UserSearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserModel> allUsers,
      List<UserModel> filteredUsers,
      bool loading,
      String? error});
}

/// @nodoc
class __$$UserSearchStateImplCopyWithImpl<$Res>
    extends _$UserSearchStateCopyWithImpl<$Res, _$UserSearchStateImpl>
    implements _$$UserSearchStateImplCopyWith<$Res> {
  __$$UserSearchStateImplCopyWithImpl(
      _$UserSearchStateImpl _value, $Res Function(_$UserSearchStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allUsers = null,
    Object? filteredUsers = null,
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(_$UserSearchStateImpl(
      allUsers: null == allUsers
          ? _value._allUsers
          : allUsers // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      filteredUsers: null == filteredUsers
          ? _value._filteredUsers
          : filteredUsers // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
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

class _$UserSearchStateImpl implements _UserSearchState {
  const _$UserSearchStateImpl(
      {final List<UserModel> allUsers = const [],
      final List<UserModel> filteredUsers = const [],
      this.loading = false,
      this.error})
      : _allUsers = allUsers,
        _filteredUsers = filteredUsers;

  final List<UserModel> _allUsers;
  @override
  @JsonKey()
  List<UserModel> get allUsers {
    if (_allUsers is EqualUnmodifiableListView) return _allUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allUsers);
  }

  final List<UserModel> _filteredUsers;
  @override
  @JsonKey()
  List<UserModel> get filteredUsers {
    if (_filteredUsers is EqualUnmodifiableListView) return _filteredUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredUsers);
  }

  @override
  @JsonKey()
  final bool loading;
  @override
  final String? error;

  @override
  String toString() {
    return 'UserSearchState(allUsers: $allUsers, filteredUsers: $filteredUsers, loading: $loading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSearchStateImpl &&
            const DeepCollectionEquality().equals(other._allUsers, _allUsers) &&
            const DeepCollectionEquality()
                .equals(other._filteredUsers, _filteredUsers) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allUsers),
      const DeepCollectionEquality().hash(_filteredUsers),
      loading,
      error);

  /// Create a copy of UserSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSearchStateImplCopyWith<_$UserSearchStateImpl> get copyWith =>
      __$$UserSearchStateImplCopyWithImpl<_$UserSearchStateImpl>(
          this, _$identity);
}

abstract class _UserSearchState implements UserSearchState {
  const factory _UserSearchState(
      {final List<UserModel> allUsers,
      final List<UserModel> filteredUsers,
      final bool loading,
      final String? error}) = _$UserSearchStateImpl;

  @override
  List<UserModel> get allUsers;
  @override
  List<UserModel> get filteredUsers;
  @override
  bool get loading;
  @override
  String? get error;

  /// Create a copy of UserSearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSearchStateImplCopyWith<_$UserSearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
