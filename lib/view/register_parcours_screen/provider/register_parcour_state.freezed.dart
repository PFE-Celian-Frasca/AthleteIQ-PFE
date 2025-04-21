// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_parcour_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RegisterParcourState {
  bool get isLoading => throw _privateConstructorUsedError;
  @SportTypeConverter()
  SportType get sportType => throw _privateConstructorUsedError;
  @ParcoursTypeConverter()
  ParcoursType get parcourType => throw _privateConstructorUsedError;
  List<String> get friendsToShare => throw _privateConstructorUsedError;
  List<UserModel> get friends => throw _privateConstructorUsedError;
  UserModel? get owner => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<LocationDataModel> get recordedLocations =>
      throw _privateConstructorUsedError;
  double? get totalDistance => throw _privateConstructorUsedError;
  double? get maxAltitude => throw _privateConstructorUsedError;
  double? get minAltitude => throw _privateConstructorUsedError;
  double? get elevationGain => throw _privateConstructorUsedError;
  double? get elevationLoss => throw _privateConstructorUsedError;
  double? get minSpeed => throw _privateConstructorUsedError;
  double? get maxSpeed => throw _privateConstructorUsedError;
  double? get averageSpeed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegisterParcourStateCopyWith<RegisterParcourState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterParcourStateCopyWith<$Res> {
  factory $RegisterParcourStateCopyWith(RegisterParcourState value,
          $Res Function(RegisterParcourState) then) =
      _$RegisterParcourStateCopyWithImpl<$Res, RegisterParcourState>;
  @useResult
  $Res call(
      {bool isLoading,
      @SportTypeConverter() SportType sportType,
      @ParcoursTypeConverter() ParcoursType parcourType,
      List<String> friendsToShare,
      List<UserModel> friends,
      UserModel? owner,
      String? title,
      String? description,
      List<LocationDataModel> recordedLocations,
      double? totalDistance,
      double? maxAltitude,
      double? minAltitude,
      double? elevationGain,
      double? elevationLoss,
      double? minSpeed,
      double? maxSpeed,
      double? averageSpeed});

  $UserModelCopyWith<$Res>? get owner;
}

/// @nodoc
class _$RegisterParcourStateCopyWithImpl<$Res,
        $Val extends RegisterParcourState>
    implements $RegisterParcourStateCopyWith<$Res> {
  _$RegisterParcourStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? sportType = null,
    Object? parcourType = null,
    Object? friendsToShare = null,
    Object? friends = null,
    Object? owner = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? recordedLocations = null,
    Object? totalDistance = freezed,
    Object? maxAltitude = freezed,
    Object? minAltitude = freezed,
    Object? elevationGain = freezed,
    Object? elevationLoss = freezed,
    Object? minSpeed = freezed,
    Object? maxSpeed = freezed,
    Object? averageSpeed = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      sportType: null == sportType
          ? _value.sportType
          : sportType // ignore: cast_nullable_to_non_nullable
              as SportType,
      parcourType: null == parcourType
          ? _value.parcourType
          : parcourType // ignore: cast_nullable_to_non_nullable
              as ParcoursType,
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
      recordedLocations: null == recordedLocations
          ? _value.recordedLocations
          : recordedLocations // ignore: cast_nullable_to_non_nullable
              as List<LocationDataModel>,
      totalDistance: freezed == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      maxAltitude: freezed == maxAltitude
          ? _value.maxAltitude
          : maxAltitude // ignore: cast_nullable_to_non_nullable
              as double?,
      minAltitude: freezed == minAltitude
          ? _value.minAltitude
          : minAltitude // ignore: cast_nullable_to_non_nullable
              as double?,
      elevationGain: freezed == elevationGain
          ? _value.elevationGain
          : elevationGain // ignore: cast_nullable_to_non_nullable
              as double?,
      elevationLoss: freezed == elevationLoss
          ? _value.elevationLoss
          : elevationLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      minSpeed: freezed == minSpeed
          ? _value.minSpeed
          : minSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      averageSpeed: freezed == averageSpeed
          ? _value.averageSpeed
          : averageSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

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
abstract class _$$RegisterParcourStateImplCopyWith<$Res>
    implements $RegisterParcourStateCopyWith<$Res> {
  factory _$$RegisterParcourStateImplCopyWith(_$RegisterParcourStateImpl value,
          $Res Function(_$RegisterParcourStateImpl) then) =
      __$$RegisterParcourStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      @SportTypeConverter() SportType sportType,
      @ParcoursTypeConverter() ParcoursType parcourType,
      List<String> friendsToShare,
      List<UserModel> friends,
      UserModel? owner,
      String? title,
      String? description,
      List<LocationDataModel> recordedLocations,
      double? totalDistance,
      double? maxAltitude,
      double? minAltitude,
      double? elevationGain,
      double? elevationLoss,
      double? minSpeed,
      double? maxSpeed,
      double? averageSpeed});

  @override
  $UserModelCopyWith<$Res>? get owner;
}

/// @nodoc
class __$$RegisterParcourStateImplCopyWithImpl<$Res>
    extends _$RegisterParcourStateCopyWithImpl<$Res, _$RegisterParcourStateImpl>
    implements _$$RegisterParcourStateImplCopyWith<$Res> {
  __$$RegisterParcourStateImplCopyWithImpl(_$RegisterParcourStateImpl _value,
      $Res Function(_$RegisterParcourStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? sportType = null,
    Object? parcourType = null,
    Object? friendsToShare = null,
    Object? friends = null,
    Object? owner = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? recordedLocations = null,
    Object? totalDistance = freezed,
    Object? maxAltitude = freezed,
    Object? minAltitude = freezed,
    Object? elevationGain = freezed,
    Object? elevationLoss = freezed,
    Object? minSpeed = freezed,
    Object? maxSpeed = freezed,
    Object? averageSpeed = freezed,
  }) {
    return _then(_$RegisterParcourStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      sportType: null == sportType
          ? _value.sportType
          : sportType // ignore: cast_nullable_to_non_nullable
              as SportType,
      parcourType: null == parcourType
          ? _value.parcourType
          : parcourType // ignore: cast_nullable_to_non_nullable
              as ParcoursType,
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
      recordedLocations: null == recordedLocations
          ? _value._recordedLocations
          : recordedLocations // ignore: cast_nullable_to_non_nullable
              as List<LocationDataModel>,
      totalDistance: freezed == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      maxAltitude: freezed == maxAltitude
          ? _value.maxAltitude
          : maxAltitude // ignore: cast_nullable_to_non_nullable
              as double?,
      minAltitude: freezed == minAltitude
          ? _value.minAltitude
          : minAltitude // ignore: cast_nullable_to_non_nullable
              as double?,
      elevationGain: freezed == elevationGain
          ? _value.elevationGain
          : elevationGain // ignore: cast_nullable_to_non_nullable
              as double?,
      elevationLoss: freezed == elevationLoss
          ? _value.elevationLoss
          : elevationLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      minSpeed: freezed == minSpeed
          ? _value.minSpeed
          : minSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      averageSpeed: freezed == averageSpeed
          ? _value.averageSpeed
          : averageSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$RegisterParcourStateImpl implements _RegisterParcourState {
  const _$RegisterParcourStateImpl(
      {this.isLoading = false,
      @SportTypeConverter() this.sportType = SportType.Marche,
      @ParcoursTypeConverter() this.parcourType = ParcoursType.Private,
      final List<String> friendsToShare = const [],
      final List<UserModel> friends = const [],
      this.owner,
      this.title,
      this.description,
      final List<LocationDataModel> recordedLocations = const [],
      this.totalDistance,
      this.maxAltitude,
      this.minAltitude,
      this.elevationGain,
      this.elevationLoss,
      this.minSpeed,
      this.maxSpeed,
      this.averageSpeed})
      : _friendsToShare = friendsToShare,
        _friends = friends,
        _recordedLocations = recordedLocations;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  @SportTypeConverter()
  final SportType sportType;
  @override
  @JsonKey()
  @ParcoursTypeConverter()
  final ParcoursType parcourType;
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
  final List<LocationDataModel> _recordedLocations;
  @override
  @JsonKey()
  List<LocationDataModel> get recordedLocations {
    if (_recordedLocations is EqualUnmodifiableListView)
      return _recordedLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recordedLocations);
  }

  @override
  final double? totalDistance;
  @override
  final double? maxAltitude;
  @override
  final double? minAltitude;
  @override
  final double? elevationGain;
  @override
  final double? elevationLoss;
  @override
  final double? minSpeed;
  @override
  final double? maxSpeed;
  @override
  final double? averageSpeed;

  @override
  String toString() {
    return 'RegisterParcourState(isLoading: $isLoading, sportType: $sportType, parcourType: $parcourType, friendsToShare: $friendsToShare, friends: $friends, owner: $owner, title: $title, description: $description, recordedLocations: $recordedLocations, totalDistance: $totalDistance, maxAltitude: $maxAltitude, minAltitude: $minAltitude, elevationGain: $elevationGain, elevationLoss: $elevationLoss, minSpeed: $minSpeed, maxSpeed: $maxSpeed, averageSpeed: $averageSpeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterParcourStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.sportType, sportType) ||
                other.sportType == sportType) &&
            (identical(other.parcourType, parcourType) ||
                other.parcourType == parcourType) &&
            const DeepCollectionEquality()
                .equals(other._friendsToShare, _friendsToShare) &&
            const DeepCollectionEquality().equals(other._friends, _friends) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._recordedLocations, _recordedLocations) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.maxAltitude, maxAltitude) ||
                other.maxAltitude == maxAltitude) &&
            (identical(other.minAltitude, minAltitude) ||
                other.minAltitude == minAltitude) &&
            (identical(other.elevationGain, elevationGain) ||
                other.elevationGain == elevationGain) &&
            (identical(other.elevationLoss, elevationLoss) ||
                other.elevationLoss == elevationLoss) &&
            (identical(other.minSpeed, minSpeed) ||
                other.minSpeed == minSpeed) &&
            (identical(other.maxSpeed, maxSpeed) ||
                other.maxSpeed == maxSpeed) &&
            (identical(other.averageSpeed, averageSpeed) ||
                other.averageSpeed == averageSpeed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      sportType,
      parcourType,
      const DeepCollectionEquality().hash(_friendsToShare),
      const DeepCollectionEquality().hash(_friends),
      owner,
      title,
      description,
      const DeepCollectionEquality().hash(_recordedLocations),
      totalDistance,
      maxAltitude,
      minAltitude,
      elevationGain,
      elevationLoss,
      minSpeed,
      maxSpeed,
      averageSpeed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterParcourStateImplCopyWith<_$RegisterParcourStateImpl>
      get copyWith =>
          __$$RegisterParcourStateImplCopyWithImpl<_$RegisterParcourStateImpl>(
              this, _$identity);
}

abstract class _RegisterParcourState implements RegisterParcourState {
  const factory _RegisterParcourState(
      {final bool isLoading,
      @SportTypeConverter() final SportType sportType,
      @ParcoursTypeConverter() final ParcoursType parcourType,
      final List<String> friendsToShare,
      final List<UserModel> friends,
      final UserModel? owner,
      final String? title,
      final String? description,
      final List<LocationDataModel> recordedLocations,
      final double? totalDistance,
      final double? maxAltitude,
      final double? minAltitude,
      final double? elevationGain,
      final double? elevationLoss,
      final double? minSpeed,
      final double? maxSpeed,
      final double? averageSpeed}) = _$RegisterParcourStateImpl;

  @override
  bool get isLoading;
  @override
  @SportTypeConverter()
  SportType get sportType;
  @override
  @ParcoursTypeConverter()
  ParcoursType get parcourType;
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
  @override
  List<LocationDataModel> get recordedLocations;
  @override
  double? get totalDistance;
  @override
  double? get maxAltitude;
  @override
  double? get minAltitude;
  @override
  double? get elevationGain;
  @override
  double? get elevationLoss;
  @override
  double? get minSpeed;
  @override
  double? get maxSpeed;
  @override
  double? get averageSpeed;
  @override
  @JsonKey(ignore: true)
  _$$RegisterParcourStateImplCopyWith<_$RegisterParcourStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
