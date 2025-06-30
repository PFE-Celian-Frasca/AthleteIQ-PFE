// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get pseudo => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  List<String> get friends => throw _privateConstructorUsedError;
  List<String> get sentFriendRequests => throw _privateConstructorUsedError;
  List<String> get receivedFriendRequests => throw _privateConstructorUsedError;
  List<String> get fav => throw _privateConstructorUsedError;
  String get sex => throw _privateConstructorUsedError;
  double get objectif => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  double get totalDist => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String pseudo,
      String image,
      String email,
      List<String> friends,
      List<String> sentFriendRequests,
      List<String> receivedFriendRequests,
      List<String> fav,
      String sex,
      double objectif,
      DateTime createdAt,
      double totalDist,
      String? fcmToken});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pseudo = null,
    Object? image = null,
    Object? email = null,
    Object? friends = null,
    Object? sentFriendRequests = null,
    Object? receivedFriendRequests = null,
    Object? fav = null,
    Object? sex = null,
    Object? objectif = null,
    Object? createdAt = null,
    Object? totalDist = null,
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pseudo: null == pseudo
          ? _value.pseudo
          : pseudo // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      friends: null == friends
          ? _value.friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sentFriendRequests: null == sentFriendRequests
          ? _value.sentFriendRequests
          : sentFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      receivedFriendRequests: null == receivedFriendRequests
          ? _value.receivedFriendRequests
          : receivedFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fav: null == fav
          ? _value.fav
          : fav // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sex: null == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String,
      objectif: null == objectif
          ? _value.objectif
          : objectif // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalDist: null == totalDist
          ? _value.totalDist
          : totalDist // ignore: cast_nullable_to_non_nullable
              as double,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pseudo,
      String image,
      String email,
      List<String> friends,
      List<String> sentFriendRequests,
      List<String> receivedFriendRequests,
      List<String> fav,
      String sex,
      double objectif,
      DateTime createdAt,
      double totalDist,
      String? fcmToken});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pseudo = null,
    Object? image = null,
    Object? email = null,
    Object? friends = null,
    Object? sentFriendRequests = null,
    Object? receivedFriendRequests = null,
    Object? fav = null,
    Object? sex = null,
    Object? objectif = null,
    Object? createdAt = null,
    Object? totalDist = null,
    Object? fcmToken = freezed,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pseudo: null == pseudo
          ? _value.pseudo
          : pseudo // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      friends: null == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sentFriendRequests: null == sentFriendRequests
          ? _value._sentFriendRequests
          : sentFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      receivedFriendRequests: null == receivedFriendRequests
          ? _value._receivedFriendRequests
          : receivedFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fav: null == fav
          ? _value._fav
          : fav // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sex: null == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String,
      objectif: null == objectif
          ? _value.objectif
          : objectif // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalDist: null == totalDist
          ? _value.totalDist
          : totalDist // ignore: cast_nullable_to_non_nullable
              as double,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.pseudo,
      this.image =
          "https://w7.pngwing.com/pngs/177/551/png-transparent-user-interface-design-computer-icons-default-stephen-salazar-graphy-user-interface-design-computer-wallpaper-sphere-thumbnail.png",
      required this.email,
      final List<String> friends = const [],
      final List<String> sentFriendRequests = const [],
      final List<String> receivedFriendRequests = const [],
      final List<String> fav = const [],
      required this.sex,
      this.objectif = 5.0,
      required this.createdAt,
      this.totalDist = 0.0,
      this.fcmToken})
      : _friends = friends,
        _sentFriendRequests = sentFriendRequests,
        _receivedFriendRequests = receivedFriendRequests,
        _fav = fav;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String pseudo;
  @override
  @JsonKey()
  final String image;
  @override
  final String email;
  final List<String> _friends;
  @override
  @JsonKey()
  List<String> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  final List<String> _sentFriendRequests;
  @override
  @JsonKey()
  List<String> get sentFriendRequests {
    if (_sentFriendRequests is EqualUnmodifiableListView)
      return _sentFriendRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sentFriendRequests);
  }

  final List<String> _receivedFriendRequests;
  @override
  @JsonKey()
  List<String> get receivedFriendRequests {
    if (_receivedFriendRequests is EqualUnmodifiableListView)
      return _receivedFriendRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_receivedFriendRequests);
  }

  final List<String> _fav;
  @override
  @JsonKey()
  List<String> get fav {
    if (_fav is EqualUnmodifiableListView) return _fav;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fav);
  }

  @override
  final String sex;
  @override
  @JsonKey()
  final double objectif;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final double totalDist;
  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'UserModel(id: $id, pseudo: $pseudo, image: $image, email: $email, friends: $friends, sentFriendRequests: $sentFriendRequests, receivedFriendRequests: $receivedFriendRequests, fav: $fav, sex: $sex, objectif: $objectif, createdAt: $createdAt, totalDist: $totalDist, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pseudo, pseudo) || other.pseudo == pseudo) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(other._friends, _friends) &&
            const DeepCollectionEquality()
                .equals(other._sentFriendRequests, _sentFriendRequests) &&
            const DeepCollectionEquality().equals(
                other._receivedFriendRequests, _receivedFriendRequests) &&
            const DeepCollectionEquality().equals(other._fav, _fav) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.objectif, objectif) ||
                other.objectif == objectif) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.totalDist, totalDist) ||
                other.totalDist == totalDist) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      pseudo,
      image,
      email,
      const DeepCollectionEquality().hash(_friends),
      const DeepCollectionEquality().hash(_sentFriendRequests),
      const DeepCollectionEquality().hash(_receivedFriendRequests),
      const DeepCollectionEquality().hash(_fav),
      sex,
      objectif,
      createdAt,
      totalDist,
      fcmToken);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String id,
      required final String pseudo,
      final String image,
      required final String email,
      final List<String> friends,
      final List<String> sentFriendRequests,
      final List<String> receivedFriendRequests,
      final List<String> fav,
      required final String sex,
      final double objectif,
      required final DateTime createdAt,
      final double totalDist,
      final String? fcmToken}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get pseudo;
  @override
  String get image;
  @override
  String get email;
  @override
  List<String> get friends;
  @override
  List<String> get sentFriendRequests;
  @override
  List<String> get receivedFriendRequests;
  @override
  List<String> get fav;
  @override
  String get sex;
  @override
  double get objectif;
  @override
  DateTime get createdAt;
  @override
  double get totalDist;
  @override
  String? get fcmToken;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
