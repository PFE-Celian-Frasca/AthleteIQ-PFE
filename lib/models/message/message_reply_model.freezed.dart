// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_reply_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageReplyModel _$MessageReplyModelFromJson(Map<String, dynamic> json) {
  return _MessageReplyModel.fromJson(json);
}

/// @nodoc
mixin _$MessageReplyModel {
  String get message => throw _privateConstructorUsedError;
  String get senderUID => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get senderImage => throw _privateConstructorUsedError;
  MessageEnum get messageType => throw _privateConstructorUsedError;
  bool get isMe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageReplyModelCopyWith<MessageReplyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageReplyModelCopyWith<$Res> {
  factory $MessageReplyModelCopyWith(
          MessageReplyModel value, $Res Function(MessageReplyModel) then) =
      _$MessageReplyModelCopyWithImpl<$Res, MessageReplyModel>;
  @useResult
  $Res call(
      {String message,
      String senderUID,
      String senderName,
      String senderImage,
      MessageEnum messageType,
      bool isMe});
}

/// @nodoc
class _$MessageReplyModelCopyWithImpl<$Res, $Val extends MessageReplyModel>
    implements $MessageReplyModelCopyWith<$Res> {
  _$MessageReplyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? senderUID = null,
    Object? senderName = null,
    Object? senderImage = null,
    Object? messageType = null,
    Object? isMe = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      senderUID: null == senderUID
          ? _value.senderUID
          : senderUID // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderImage: null == senderImage
          ? _value.senderImage
          : senderImage // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageReplyModelImplCopyWith<$Res>
    implements $MessageReplyModelCopyWith<$Res> {
  factory _$$MessageReplyModelImplCopyWith(_$MessageReplyModelImpl value,
          $Res Function(_$MessageReplyModelImpl) then) =
      __$$MessageReplyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      String senderUID,
      String senderName,
      String senderImage,
      MessageEnum messageType,
      bool isMe});
}

/// @nodoc
class __$$MessageReplyModelImplCopyWithImpl<$Res>
    extends _$MessageReplyModelCopyWithImpl<$Res, _$MessageReplyModelImpl>
    implements _$$MessageReplyModelImplCopyWith<$Res> {
  __$$MessageReplyModelImplCopyWithImpl(_$MessageReplyModelImpl _value,
      $Res Function(_$MessageReplyModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? senderUID = null,
    Object? senderName = null,
    Object? senderImage = null,
    Object? messageType = null,
    Object? isMe = null,
  }) {
    return _then(_$MessageReplyModelImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      senderUID: null == senderUID
          ? _value.senderUID
          : senderUID // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderImage: null == senderImage
          ? _value.senderImage
          : senderImage // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageReplyModelImpl implements _MessageReplyModel {
  const _$MessageReplyModelImpl(
      {required this.message,
      required this.senderUID,
      required this.senderName,
      required this.senderImage,
      required this.messageType,
      required this.isMe});

  factory _$MessageReplyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageReplyModelImplFromJson(json);

  @override
  final String message;
  @override
  final String senderUID;
  @override
  final String senderName;
  @override
  final String senderImage;
  @override
  final MessageEnum messageType;
  @override
  final bool isMe;

  @override
  String toString() {
    return 'MessageReplyModel(message: $message, senderUID: $senderUID, senderName: $senderName, senderImage: $senderImage, messageType: $messageType, isMe: $isMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageReplyModelImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.senderUID, senderUID) ||
                other.senderUID == senderUID) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderImage, senderImage) ||
                other.senderImage == senderImage) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.isMe, isMe) || other.isMe == isMe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, senderUID, senderName,
      senderImage, messageType, isMe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageReplyModelImplCopyWith<_$MessageReplyModelImpl> get copyWith =>
      __$$MessageReplyModelImplCopyWithImpl<_$MessageReplyModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageReplyModelImplToJson(
      this,
    );
  }
}

abstract class _MessageReplyModel implements MessageReplyModel {
  const factory _MessageReplyModel(
      {required final String message,
      required final String senderUID,
      required final String senderName,
      required final String senderImage,
      required final MessageEnum messageType,
      required final bool isMe}) = _$MessageReplyModelImpl;

  factory _MessageReplyModel.fromJson(Map<String, dynamic> json) =
      _$MessageReplyModelImpl.fromJson;

  @override
  String get message;
  @override
  String get senderUID;
  @override
  String get senderName;
  @override
  String get senderImage;
  @override
  MessageEnum get messageType;
  @override
  bool get isMe;
  @override
  @JsonKey(ignore: true)
  _$$MessageReplyModelImplCopyWith<_$MessageReplyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
