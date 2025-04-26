// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcours_with_gps_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ParcoursWithGPSData _$ParcoursWithGPSDataFromJson(Map<String, dynamic> json) {
  return _ParcoursWithGPSData.fromJson(json);
}

/// @nodoc
mixin _$ParcoursWithGPSData {
  ParcoursModel get parcours => throw _privateConstructorUsedError;
  List<LocationDataModel> get gpsData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParcoursWithGPSDataCopyWith<ParcoursWithGPSData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParcoursWithGPSDataCopyWith<$Res> {
  factory $ParcoursWithGPSDataCopyWith(
          ParcoursWithGPSData value, $Res Function(ParcoursWithGPSData) then) =
      _$ParcoursWithGPSDataCopyWithImpl<$Res, ParcoursWithGPSData>;
  @useResult
  $Res call({ParcoursModel parcours, List<LocationDataModel> gpsData});

  $ParcoursModelCopyWith<$Res> get parcours;
}

/// @nodoc
class _$ParcoursWithGPSDataCopyWithImpl<$Res, $Val extends ParcoursWithGPSData>
    implements $ParcoursWithGPSDataCopyWith<$Res> {
  _$ParcoursWithGPSDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parcours = null,
    Object? gpsData = null,
  }) {
    return _then(_value.copyWith(
      parcours: null == parcours
          ? _value.parcours
          : parcours // ignore: cast_nullable_to_non_nullable
              as ParcoursModel,
      gpsData: null == gpsData
          ? _value.gpsData
          : gpsData // ignore: cast_nullable_to_non_nullable
              as List<LocationDataModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ParcoursModelCopyWith<$Res> get parcours {
    return $ParcoursModelCopyWith<$Res>(_value.parcours, (value) {
      return _then(_value.copyWith(parcours: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ParcoursWithGPSDataImplCopyWith<$Res>
    implements $ParcoursWithGPSDataCopyWith<$Res> {
  factory _$$ParcoursWithGPSDataImplCopyWith(_$ParcoursWithGPSDataImpl value,
          $Res Function(_$ParcoursWithGPSDataImpl) then) =
      __$$ParcoursWithGPSDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ParcoursModel parcours, List<LocationDataModel> gpsData});

  @override
  $ParcoursModelCopyWith<$Res> get parcours;
}

/// @nodoc
class __$$ParcoursWithGPSDataImplCopyWithImpl<$Res>
    extends _$ParcoursWithGPSDataCopyWithImpl<$Res, _$ParcoursWithGPSDataImpl>
    implements _$$ParcoursWithGPSDataImplCopyWith<$Res> {
  __$$ParcoursWithGPSDataImplCopyWithImpl(_$ParcoursWithGPSDataImpl _value,
      $Res Function(_$ParcoursWithGPSDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parcours = null,
    Object? gpsData = null,
  }) {
    return _then(_$ParcoursWithGPSDataImpl(
      parcours: null == parcours
          ? _value.parcours
          : parcours // ignore: cast_nullable_to_non_nullable
              as ParcoursModel,
      gpsData: null == gpsData
          ? _value._gpsData
          : gpsData // ignore: cast_nullable_to_non_nullable
              as List<LocationDataModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParcoursWithGPSDataImpl extends _ParcoursWithGPSData {
  const _$ParcoursWithGPSDataImpl(
      {required this.parcours, required final List<LocationDataModel> gpsData})
      : _gpsData = gpsData,
        super._();

  factory _$ParcoursWithGPSDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParcoursWithGPSDataImplFromJson(json);

  @override
  final ParcoursModel parcours;
  final List<LocationDataModel> _gpsData;
  @override
  List<LocationDataModel> get gpsData {
    if (_gpsData is EqualUnmodifiableListView) return _gpsData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gpsData);
  }

  @override
  String toString() {
    return 'ParcoursWithGPSData(parcours: $parcours, gpsData: $gpsData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParcoursWithGPSDataImpl &&
            (identical(other.parcours, parcours) ||
                other.parcours == parcours) &&
            const DeepCollectionEquality().equals(other._gpsData, _gpsData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, parcours, const DeepCollectionEquality().hash(_gpsData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParcoursWithGPSDataImplCopyWith<_$ParcoursWithGPSDataImpl> get copyWith =>
      __$$ParcoursWithGPSDataImplCopyWithImpl<_$ParcoursWithGPSDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParcoursWithGPSDataImplToJson(
      this,
    );
  }
}

abstract class _ParcoursWithGPSData extends ParcoursWithGPSData {
  const factory _ParcoursWithGPSData(
          {required final ParcoursModel parcours,
          required final List<LocationDataModel> gpsData}) =
      _$ParcoursWithGPSDataImpl;
  const _ParcoursWithGPSData._() : super._();

  factory _ParcoursWithGPSData.fromJson(Map<String, dynamic> json) =
      _$ParcoursWithGPSDataImpl.fromJson;

  @override
  ParcoursModel get parcours;
  @override
  List<LocationDataModel> get gpsData;
  @override
  @JsonKey(ignore: true)
  _$$ParcoursWithGPSDataImplCopyWith<_$ParcoursWithGPSDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
