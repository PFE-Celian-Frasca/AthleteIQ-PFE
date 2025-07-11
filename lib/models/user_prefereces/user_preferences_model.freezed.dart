// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPreferencesModel _$UserPreferencesModelFromJson(Map<String, dynamic> json) {
  return _UserPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$UserPreferencesModel {
  bool get receiveNotifications => throw _privateConstructorUsedError;
  bool get darkModeEnabled => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;

  /// Serializes this UserPreferencesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesModelCopyWith<UserPreferencesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesModelCopyWith<$Res> {
  factory $UserPreferencesModelCopyWith(
          UserPreferencesModel value, $Res Function(UserPreferencesModel) then) =
      _$UserPreferencesModelCopyWithImpl<$Res, UserPreferencesModel>;
  @useResult
  $Res call({bool receiveNotifications, bool darkModeEnabled, String language});
}

/// @nodoc
class _$UserPreferencesModelCopyWithImpl<$Res, $Val extends UserPreferencesModel>
    implements $UserPreferencesModelCopyWith<$Res> {
  _$UserPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receiveNotifications = null,
    Object? darkModeEnabled = null,
    Object? language = null,
  }) {
    return _then(_value.copyWith(
      receiveNotifications: null == receiveNotifications
          ? _value.receiveNotifications
          : receiveNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      darkModeEnabled: null == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferencesModelImplCopyWith<$Res>
    implements $UserPreferencesModelCopyWith<$Res> {
  factory _$$UserPreferencesModelImplCopyWith(
          _$UserPreferencesModelImpl value, $Res Function(_$UserPreferencesModelImpl) then) =
      __$$UserPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool receiveNotifications, bool darkModeEnabled, String language});
}

/// @nodoc
class __$$UserPreferencesModelImplCopyWithImpl<$Res>
    extends _$UserPreferencesModelCopyWithImpl<$Res, _$UserPreferencesModelImpl>
    implements _$$UserPreferencesModelImplCopyWith<$Res> {
  __$$UserPreferencesModelImplCopyWithImpl(
      _$UserPreferencesModelImpl _value, $Res Function(_$UserPreferencesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receiveNotifications = null,
    Object? darkModeEnabled = null,
    Object? language = null,
  }) {
    return _then(_$UserPreferencesModelImpl(
      receiveNotifications: null == receiveNotifications
          ? _value.receiveNotifications
          : receiveNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      darkModeEnabled: null == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesModelImpl implements _UserPreferencesModel {
  const _$UserPreferencesModelImpl(
      {this.receiveNotifications = true, this.darkModeEnabled = true, this.language = ''});

  factory _$UserPreferencesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesModelImplFromJson(json);

  @override
  @JsonKey()
  final bool receiveNotifications;
  @override
  @JsonKey()
  final bool darkModeEnabled;
  @override
  @JsonKey()
  final String language;

  @override
  String toString() {
    return 'UserPreferencesModel(receiveNotifications: $receiveNotifications, darkModeEnabled: $darkModeEnabled, language: $language)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesModelImpl &&
            (identical(other.receiveNotifications, receiveNotifications) ||
                other.receiveNotifications == receiveNotifications) &&
            (identical(other.darkModeEnabled, darkModeEnabled) ||
                other.darkModeEnabled == darkModeEnabled) &&
            (identical(other.language, language) || other.language == language));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, receiveNotifications, darkModeEnabled, language);

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesModelImplCopyWith<_$UserPreferencesModelImpl> get copyWith =>
      __$$UserPreferencesModelImplCopyWithImpl<_$UserPreferencesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _UserPreferencesModel implements UserPreferencesModel {
  const factory _UserPreferencesModel(
      {final bool receiveNotifications,
      final bool darkModeEnabled,
      final String language}) = _$UserPreferencesModelImpl;

  factory _UserPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesModelImpl.fromJson;

  @override
  bool get receiveNotifications;
  @override
  bool get darkModeEnabled;
  @override
  String get language;

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesModelImplCopyWith<_$UserPreferencesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
