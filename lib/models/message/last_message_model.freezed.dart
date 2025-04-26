// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'last_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LastMessageModel _$LastMessageModelFromJson(Map<String, dynamic> json) {
  return _LastMessageModel.fromJson(json);
}

/// @nodoc
mixin _$LastMessageModel {
  String get senderUID => throw _privateConstructorUsedError;
  String get contactUID => throw _privateConstructorUsedError;
  String get contactName => throw _privateConstructorUsedError;
  String get contactImage => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  MessageEnum get messageType => throw _privateConstructorUsedError;
  DateTime get timeSent => throw _privateConstructorUsedError;
  bool get isSeen => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LastMessageModelCopyWith<LastMessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LastMessageModelCopyWith<$Res> {
  factory $LastMessageModelCopyWith(
          LastMessageModel value, $Res Function(LastMessageModel) then) =
      _$LastMessageModelCopyWithImpl<$Res, LastMessageModel>;
  @useResult
  $Res call(
      {String senderUID,
      String contactUID,
      String contactName,
      String contactImage,
      String message,
      MessageEnum messageType,
      DateTime timeSent,
      bool isSeen});
}

/// @nodoc
class _$LastMessageModelCopyWithImpl<$Res, $Val extends LastMessageModel>
    implements $LastMessageModelCopyWith<$Res> {
  _$LastMessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderUID = null,
    Object? contactUID = null,
    Object? contactName = null,
    Object? contactImage = null,
    Object? message = null,
    Object? messageType = null,
    Object? timeSent = null,
    Object? isSeen = null,
  }) {
    return _then(_value.copyWith(
      senderUID: null == senderUID
          ? _value.senderUID
          : senderUID // ignore: cast_nullable_to_non_nullable
              as String,
      contactUID: null == contactUID
          ? _value.contactUID
          : contactUID // ignore: cast_nullable_to_non_nullable
              as String,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactImage: null == contactImage
          ? _value.contactImage
          : contactImage // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LastMessageModelImplCopyWith<$Res>
    implements $LastMessageModelCopyWith<$Res> {
  factory _$$LastMessageModelImplCopyWith(_$LastMessageModelImpl value,
          $Res Function(_$LastMessageModelImpl) then) =
      __$$LastMessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String senderUID,
      String contactUID,
      String contactName,
      String contactImage,
      String message,
      MessageEnum messageType,
      DateTime timeSent,
      bool isSeen});
}

/// @nodoc
class __$$LastMessageModelImplCopyWithImpl<$Res>
    extends _$LastMessageModelCopyWithImpl<$Res, _$LastMessageModelImpl>
    implements _$$LastMessageModelImplCopyWith<$Res> {
  __$$LastMessageModelImplCopyWithImpl(_$LastMessageModelImpl _value,
      $Res Function(_$LastMessageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderUID = null,
    Object? contactUID = null,
    Object? contactName = null,
    Object? contactImage = null,
    Object? message = null,
    Object? messageType = null,
    Object? timeSent = null,
    Object? isSeen = null,
  }) {
    return _then(_$LastMessageModelImpl(
      senderUID: null == senderUID
          ? _value.senderUID
          : senderUID // ignore: cast_nullable_to_non_nullable
              as String,
      contactUID: null == contactUID
          ? _value.contactUID
          : contactUID // ignore: cast_nullable_to_non_nullable
              as String,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactImage: null == contactImage
          ? _value.contactImage
          : contactImage // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LastMessageModelImpl implements _LastMessageModel {
  const _$LastMessageModelImpl(
      {required this.senderUID,
      required this.contactUID,
      required this.contactName,
      required this.contactImage,
      required this.message,
      required this.messageType,
      required this.timeSent,
      required this.isSeen});

  factory _$LastMessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LastMessageModelImplFromJson(json);

  @override
  final String senderUID;
  @override
  final String contactUID;
  @override
  final String contactName;
  @override
  final String contactImage;
  @override
  final String message;
  @override
  final MessageEnum messageType;
  @override
  final DateTime timeSent;
  @override
  final bool isSeen;

  @override
  String toString() {
    return 'LastMessageModel(senderUID: $senderUID, contactUID: $contactUID, contactName: $contactName, contactImage: $contactImage, message: $message, messageType: $messageType, timeSent: $timeSent, isSeen: $isSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LastMessageModelImpl &&
            (identical(other.senderUID, senderUID) ||
                other.senderUID == senderUID) &&
            (identical(other.contactUID, contactUID) ||
                other.contactUID == contactUID) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.contactImage, contactImage) ||
                other.contactImage == contactImage) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.timeSent, timeSent) ||
                other.timeSent == timeSent) &&
            (identical(other.isSeen, isSeen) || other.isSeen == isSeen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, senderUID, contactUID,
      contactName, contactImage, message, messageType, timeSent, isSeen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LastMessageModelImplCopyWith<_$LastMessageModelImpl> get copyWith =>
      __$$LastMessageModelImplCopyWithImpl<_$LastMessageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LastMessageModelImplToJson(
      this,
    );
  }
}

abstract class _LastMessageModel implements LastMessageModel {
  const factory _LastMessageModel(
      {required final String senderUID,
      required final String contactUID,
      required final String contactName,
      required final String contactImage,
      required final String message,
      required final MessageEnum messageType,
      required final DateTime timeSent,
      required final bool isSeen}) = _$LastMessageModelImpl;

  factory _LastMessageModel.fromJson(Map<String, dynamic> json) =
      _$LastMessageModelImpl.fromJson;

  @override
  String get senderUID;
  @override
  String get contactUID;
  @override
  String get contactName;
  @override
  String get contactImage;
  @override
  String get message;
  @override
  MessageEnum get messageType;
  @override
  DateTime get timeSent;
  @override
  bool get isSeen;
  @override
  @JsonKey(ignore: true)
  _$$LastMessageModelImplCopyWith<_$LastMessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
