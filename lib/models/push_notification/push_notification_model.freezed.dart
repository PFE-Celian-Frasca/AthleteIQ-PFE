// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PushNotificationModel _$PushNotificationModelFromJson(
    Map<String, dynamic> json) {
  return _PushNotificationModel.fromJson(json);
}

/// @nodoc
mixin _$PushNotificationModel {
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Serializes this PushNotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PushNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PushNotificationModelCopyWith<PushNotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushNotificationModelCopyWith<$Res> {
  factory $PushNotificationModelCopyWith(PushNotificationModel value,
          $Res Function(PushNotificationModel) then) =
      _$PushNotificationModelCopyWithImpl<$Res, PushNotificationModel>;
  @useResult
  $Res call(
      {String title, String body, String? imageUrl, Map<String, dynamic> data});
}

/// @nodoc
class _$PushNotificationModelCopyWithImpl<$Res,
        $Val extends PushNotificationModel>
    implements $PushNotificationModelCopyWith<$Res> {
  _$PushNotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PushNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? imageUrl = freezed,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PushNotificationModelImplCopyWith<$Res>
    implements $PushNotificationModelCopyWith<$Res> {
  factory _$$PushNotificationModelImplCopyWith(
          _$PushNotificationModelImpl value,
          $Res Function(_$PushNotificationModelImpl) then) =
      __$$PushNotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title, String body, String? imageUrl, Map<String, dynamic> data});
}

/// @nodoc
class __$$PushNotificationModelImplCopyWithImpl<$Res>
    extends _$PushNotificationModelCopyWithImpl<$Res,
        _$PushNotificationModelImpl>
    implements _$$PushNotificationModelImplCopyWith<$Res> {
  __$$PushNotificationModelImplCopyWithImpl(_$PushNotificationModelImpl _value,
      $Res Function(_$PushNotificationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PushNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? imageUrl = freezed,
    Object? data = null,
  }) {
    return _then(_$PushNotificationModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PushNotificationModelImpl implements _PushNotificationModel {
  const _$PushNotificationModelImpl(
      {required this.title,
      required this.body,
      this.imageUrl,
      final Map<String, dynamic> data = const {}})
      : _data = data;

  factory _$PushNotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PushNotificationModelImplFromJson(json);

  @override
  final String title;
  @override
  final String body;
  @override
  final String? imageUrl;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'PushNotificationModel(title: $title, body: $body, imageUrl: $imageUrl, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PushNotificationModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, body, imageUrl,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of PushNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PushNotificationModelImplCopyWith<_$PushNotificationModelImpl>
      get copyWith => __$$PushNotificationModelImplCopyWithImpl<
          _$PushNotificationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PushNotificationModelImplToJson(
      this,
    );
  }
}

abstract class _PushNotificationModel implements PushNotificationModel {
  const factory _PushNotificationModel(
      {required final String title,
      required final String body,
      final String? imageUrl,
      final Map<String, dynamic> data}) = _$PushNotificationModelImpl;

  factory _PushNotificationModel.fromJson(Map<String, dynamic> json) =
      _$PushNotificationModelImpl.fromJson;

  @override
  String get title;
  @override
  String get body;
  @override
  String? get imageUrl;
  @override
  Map<String, dynamic> get data;

  /// Create a copy of PushNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PushNotificationModelImplCopyWith<_$PushNotificationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
