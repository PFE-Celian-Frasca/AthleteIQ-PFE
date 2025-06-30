// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_parcour_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdateParcourState {
  bool get isLoading => throw _privateConstructorUsedError;
  @ParcourVisibilityConverter()
  ParcourVisibility get parcourType => throw _privateConstructorUsedError;
  List<String> get friendsToShare => throw _privateConstructorUsedError;
  List<UserModel> get friends => throw _privateConstructorUsedError;
  UserModel? get owner => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Create a copy of UpdateParcourState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateParcourStateCopyWith<UpdateParcourState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateParcourStateCopyWith<$Res> {
  factory $UpdateParcourStateCopyWith(
          UpdateParcourState value, $Res Function(UpdateParcourState) then) =
      _$UpdateParcourStateCopyWithImpl<$Res, UpdateParcourState>;
  @useResult
  $Res call(
      {bool isLoading,
      @ParcourVisibilityConverter() ParcourVisibility parcourType,
      List<String> friendsToShare,
      List<UserModel> friends,
      UserModel? owner,
      String? title,
      String? description});

  $UserModelCopyWith<$Res>? get owner;
}

/// @nodoc
class _$UpdateParcourStateCopyWithImpl<$Res, $Val extends UpdateParcourState>
    implements $UpdateParcourStateCopyWith<$Res> {
  _$UpdateParcourStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateParcourState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? parcourType = null,
    Object? friendsToShare = null,
    Object? friends = null,
    Object? owner = freezed,
    Object? title = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      parcourType: null == parcourType
          ? _value.parcourType
          : parcourType // ignore: cast_nullable_to_non_nullable
              as ParcourVisibility,
      friendsToShare: null == friendsToShare
          ? _value.friendsToShare
          : friendsToShare // ignore: cast_nullable_to_non_nullable
              as List<String>,
      friends: null == friends
          ? _value.friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of UpdateParcourState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get owner {
    if (_value.owner == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.owner!, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpdateParcourStateImplCopyWith<$Res>
    implements $UpdateParcourStateCopyWith<$Res> {
  factory _$$UpdateParcourStateImplCopyWith(_$UpdateParcourStateImpl value,
          $Res Function(_$UpdateParcourStateImpl) then) =
      __$$UpdateParcourStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      @ParcourVisibilityConverter() ParcourVisibility parcourType,
      List<String> friendsToShare,
      List<UserModel> friends,
      UserModel? owner,
      String? title,
      String? description});

  @override
  $UserModelCopyWith<$Res>? get owner;
}

/// @nodoc
class __$$UpdateParcourStateImplCopyWithImpl<$Res>
    extends _$UpdateParcourStateCopyWithImpl<$Res, _$UpdateParcourStateImpl>
    implements _$$UpdateParcourStateImplCopyWith<$Res> {
  __$$UpdateParcourStateImplCopyWithImpl(_$UpdateParcourStateImpl _value,
      $Res Function(_$UpdateParcourStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateParcourState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? parcourType = null,
    Object? friendsToShare = null,
    Object? friends = null,
    Object? owner = freezed,
    Object? title = freezed,
    Object? description = freezed,
  }) {
    return _then(_$UpdateParcourStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      parcourType: null == parcourType
          ? _value.parcourType
          : parcourType // ignore: cast_nullable_to_non_nullable
              as ParcourVisibility,
      friendsToShare: null == friendsToShare
          ? _value._friendsToShare
          : friendsToShare // ignore: cast_nullable_to_non_nullable
              as List<String>,
      friends: null == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UpdateParcourStateImpl implements _UpdateParcourState {
  const _$UpdateParcourStateImpl(
      {this.isLoading = false,
      @ParcourVisibilityConverter()
      this.parcourType = ParcourVisibility.private,
      final List<String> friendsToShare = const [],
      final List<UserModel> friends = const [],
      this.owner,
      this.title,
      this.description})
      : _friendsToShare = friendsToShare,
        _friends = friends;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  @ParcourVisibilityConverter()
  final ParcourVisibility parcourType;
  final List<String> _friendsToShare;
  @override
  @JsonKey()
  List<String> get friendsToShare {
    if (_friendsToShare is EqualUnmodifiableListView) return _friendsToShare;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendsToShare);
  }

  final List<UserModel> _friends;
  @override
  @JsonKey()
  List<UserModel> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  @override
  final UserModel? owner;
  @override
  final String? title;
  @override
  final String? description;

  @override
  String toString() {
    return 'UpdateParcourState(isLoading: $isLoading, parcourType: $parcourType, friendsToShare: $friendsToShare, friends: $friends, owner: $owner, title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateParcourStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.parcourType, parcourType) ||
                other.parcourType == parcourType) &&
            const DeepCollectionEquality()
                .equals(other._friendsToShare, _friendsToShare) &&
            const DeepCollectionEquality().equals(other._friends, _friends) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      parcourType,
      const DeepCollectionEquality().hash(_friendsToShare),
      const DeepCollectionEquality().hash(_friends),
      owner,
      title,
      description);

  /// Create a copy of UpdateParcourState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateParcourStateImplCopyWith<_$UpdateParcourStateImpl> get copyWith =>
      __$$UpdateParcourStateImplCopyWithImpl<_$UpdateParcourStateImpl>(
          this, _$identity);
}

abstract class _UpdateParcourState implements UpdateParcourState {
  const factory _UpdateParcourState(
      {final bool isLoading,
      @ParcourVisibilityConverter() final ParcourVisibility parcourType,
      final List<String> friendsToShare,
      final List<UserModel> friends,
      final UserModel? owner,
      final String? title,
      final String? description}) = _$UpdateParcourStateImpl;

  @override
  bool get isLoading;
  @override
  @ParcourVisibilityConverter()
  ParcourVisibility get parcourType;
  @override
  List<String> get friendsToShare;
  @override
  List<UserModel> get friends;
  @override
  UserModel? get owner;
  @override
  String? get title;
  @override
  String? get description;

  /// Create a copy of UpdateParcourState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateParcourStateImplCopyWith<_$UpdateParcourStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
