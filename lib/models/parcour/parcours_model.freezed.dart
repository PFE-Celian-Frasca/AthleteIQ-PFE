// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcours_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ParcoursModel _$ParcoursModelFromJson(Map<String, dynamic> json) {
  return _ParcoursModel.fromJson(json);
}

/// @nodoc
mixin _$ParcoursModel {
  String? get id => throw _privateConstructorUsedError;
  String get owner => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ParcoursType get type => throw _privateConstructorUsedError;
  SportType get sportType => throw _privateConstructorUsedError;
  List<String> get shareTo => throw _privateConstructorUsedError;
  @CustomTimerConverter()
  CustomTimer get timer => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  double get vm => throw _privateConstructorUsedError;
  double get totalDistance => throw _privateConstructorUsedError;
  String? get parcoursDataUrl => throw _privateConstructorUsedError;

  /// Serializes this ParcoursModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParcoursModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParcoursModelCopyWith<ParcoursModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParcoursModelCopyWith<$Res> {
  factory $ParcoursModelCopyWith(
          ParcoursModel value, $Res Function(ParcoursModel) then) =
      _$ParcoursModelCopyWithImpl<$Res, ParcoursModel>;
  @useResult
  $Res call(
      {String? id,
      String owner,
      String title,
      String? description,
      ParcoursType type,
      SportType sportType,
      List<String> shareTo,
      @CustomTimerConverter() CustomTimer timer,
      DateTime createdAt,
      double vm,
      double totalDistance,
      String? parcoursDataUrl});

  $CustomTimerCopyWith<$Res> get timer;
}

/// @nodoc
class _$ParcoursModelCopyWithImpl<$Res, $Val extends ParcoursModel>
    implements $ParcoursModelCopyWith<$Res> {
  _$ParcoursModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParcoursModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? owner = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? sportType = null,
    Object? shareTo = null,
    Object? timer = null,
    Object? createdAt = null,
    Object? vm = null,
    Object? totalDistance = null,
    Object? parcoursDataUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ParcoursType,
      sportType: null == sportType
          ? _value.sportType
          : sportType // ignore: cast_nullable_to_non_nullable
              as SportType,
      shareTo: null == shareTo
          ? _value.shareTo
          : shareTo // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timer: null == timer
          ? _value.timer
          : timer // ignore: cast_nullable_to_non_nullable
              as CustomTimer,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      vm: null == vm
          ? _value.vm
          : vm // ignore: cast_nullable_to_non_nullable
              as double,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      parcoursDataUrl: freezed == parcoursDataUrl
          ? _value.parcoursDataUrl
          : parcoursDataUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ParcoursModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomTimerCopyWith<$Res> get timer {
    return $CustomTimerCopyWith<$Res>(_value.timer, (value) {
      return _then(_value.copyWith(timer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ParcoursModelImplCopyWith<$Res>
    implements $ParcoursModelCopyWith<$Res> {
  factory _$$ParcoursModelImplCopyWith(
          _$ParcoursModelImpl value, $Res Function(_$ParcoursModelImpl) then) =
      __$$ParcoursModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String owner,
      String title,
      String? description,
      ParcoursType type,
      SportType sportType,
      List<String> shareTo,
      @CustomTimerConverter() CustomTimer timer,
      DateTime createdAt,
      double vm,
      double totalDistance,
      String? parcoursDataUrl});

  @override
  $CustomTimerCopyWith<$Res> get timer;
}

/// @nodoc
class __$$ParcoursModelImplCopyWithImpl<$Res>
    extends _$ParcoursModelCopyWithImpl<$Res, _$ParcoursModelImpl>
    implements _$$ParcoursModelImplCopyWith<$Res> {
  __$$ParcoursModelImplCopyWithImpl(
      _$ParcoursModelImpl _value, $Res Function(_$ParcoursModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParcoursModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? owner = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? sportType = null,
    Object? shareTo = null,
    Object? timer = null,
    Object? createdAt = null,
    Object? vm = null,
    Object? totalDistance = null,
    Object? parcoursDataUrl = freezed,
  }) {
    return _then(_$ParcoursModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ParcoursType,
      sportType: null == sportType
          ? _value.sportType
          : sportType // ignore: cast_nullable_to_non_nullable
              as SportType,
      shareTo: null == shareTo
          ? _value._shareTo
          : shareTo // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timer: null == timer
          ? _value.timer
          : timer // ignore: cast_nullable_to_non_nullable
              as CustomTimer,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      vm: null == vm
          ? _value.vm
          : vm // ignore: cast_nullable_to_non_nullable
              as double,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      parcoursDataUrl: freezed == parcoursDataUrl
          ? _value.parcoursDataUrl
          : parcoursDataUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParcoursModelImpl
    with DiagnosticableTreeMixin
    implements _ParcoursModel {
  const _$ParcoursModelImpl(
      {this.id,
      required this.owner,
      required this.title,
      this.description,
      required this.type,
      required this.sportType,
      required final List<String> shareTo,
      @CustomTimerConverter() required this.timer,
      required this.createdAt,
      required this.vm,
      required this.totalDistance,
      this.parcoursDataUrl})
      : _shareTo = shareTo;

  factory _$ParcoursModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParcoursModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String owner;
  @override
  final String title;
  @override
  final String? description;
  @override
  final ParcoursType type;
  @override
  final SportType sportType;
  final List<String> _shareTo;
  @override
  List<String> get shareTo {
    if (_shareTo is EqualUnmodifiableListView) return _shareTo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shareTo);
  }

  @override
  @CustomTimerConverter()
  final CustomTimer timer;
  @override
  final DateTime createdAt;
  @override
  final double vm;
  @override
  final double totalDistance;
  @override
  final String? parcoursDataUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ParcoursModel(id: $id, owner: $owner, title: $title, description: $description, type: $type, sportType: $sportType, shareTo: $shareTo, timer: $timer, createdAt: $createdAt, vm: $vm, totalDistance: $totalDistance, parcoursDataUrl: $parcoursDataUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ParcoursModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('owner', owner))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('sportType', sportType))
      ..add(DiagnosticsProperty('shareTo', shareTo))
      ..add(DiagnosticsProperty('timer', timer))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('vm', vm))
      ..add(DiagnosticsProperty('totalDistance', totalDistance))
      ..add(DiagnosticsProperty('parcoursDataUrl', parcoursDataUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParcoursModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.sportType, sportType) ||
                other.sportType == sportType) &&
            const DeepCollectionEquality().equals(other._shareTo, _shareTo) &&
            (identical(other.timer, timer) || other.timer == timer) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.vm, vm) || other.vm == vm) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.parcoursDataUrl, parcoursDataUrl) ||
                other.parcoursDataUrl == parcoursDataUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      owner,
      title,
      description,
      type,
      sportType,
      const DeepCollectionEquality().hash(_shareTo),
      timer,
      createdAt,
      vm,
      totalDistance,
      parcoursDataUrl);

  /// Create a copy of ParcoursModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParcoursModelImplCopyWith<_$ParcoursModelImpl> get copyWith =>
      __$$ParcoursModelImplCopyWithImpl<_$ParcoursModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParcoursModelImplToJson(
      this,
    );
  }
}

abstract class _ParcoursModel implements ParcoursModel {
  const factory _ParcoursModel(
      {final String? id,
      required final String owner,
      required final String title,
      final String? description,
      required final ParcoursType type,
      required final SportType sportType,
      required final List<String> shareTo,
      @CustomTimerConverter() required final CustomTimer timer,
      required final DateTime createdAt,
      required final double vm,
      required final double totalDistance,
      final String? parcoursDataUrl}) = _$ParcoursModelImpl;

  factory _ParcoursModel.fromJson(Map<String, dynamic> json) =
      _$ParcoursModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get owner;
  @override
  String get title;
  @override
  String? get description;
  @override
  ParcoursType get type;
  @override
  SportType get sportType;
  @override
  List<String> get shareTo;
  @override
  @CustomTimerConverter()
  CustomTimer get timer;
  @override
  DateTime get createdAt;
  @override
  double get vm;
  @override
  double get totalDistance;
  @override
  String? get parcoursDataUrl;

  /// Create a copy of ParcoursModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParcoursModelImplCopyWith<_$ParcoursModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
