// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get senderUID => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get senderImage => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  MessageEnum get messageType => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get timeSent => throw _privateConstructorUsedError;
  String get messageId => throw _privateConstructorUsedError;
  bool get isSeen => throw _privateConstructorUsedError;
  String get repliedMessage => throw _privateConstructorUsedError;
  String get repliedTo => throw _privateConstructorUsedError;
  MessageEnum get repliedMessageType => throw _privateConstructorUsedError;
  List<String> get reactions => throw _privateConstructorUsedError;
  List<String> get isSeenBy => throw _privateConstructorUsedError;
  List<String> get deletedBy => throw _privateConstructorUsedError;

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageModelCopyWith<MessageModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String senderUID,
      String senderName,
      String senderImage,
      String message,
      MessageEnum messageType,
      @TimestampConverter() DateTime timeSent,
      String messageId,
      bool isSeen,
      String repliedMessage,
      String repliedTo,
      MessageEnum repliedMessageType,
      List<String> reactions,
      List<String> isSeenBy,
      List<String> deletedBy});
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderUID = null,
    Object? senderName = null,
    Object? senderImage = null,
    Object? message = null,
    Object? messageType = null,
    Object? timeSent = null,
    Object? messageId = null,
    Object? isSeen = null,
    Object? repliedMessage = null,
    Object? repliedTo = null,
    Object? repliedMessageType = null,
    Object? reactions = null,
    Object? isSeenBy = null,
    Object? deletedBy = null,
  }) {
    return _then(_value.copyWith(
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
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
      repliedMessage: null == repliedMessage
          ? _value.repliedMessage
          : repliedMessage // ignore: cast_nullable_to_non_nullable
              as String,
      repliedTo: null == repliedTo
          ? _value.repliedTo
          : repliedTo // ignore: cast_nullable_to_non_nullable
              as String,
      repliedMessageType: null == repliedMessageType
          ? _value.repliedMessageType
          : repliedMessageType // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSeenBy: null == isSeenBy
          ? _value.isSeenBy
          : isSeenBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deletedBy: null == deletedBy
          ? _value.deletedBy
          : deletedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res> implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String senderUID,
      String senderName,
      String senderImage,
      String message,
      MessageEnum messageType,
      @TimestampConverter() DateTime timeSent,
      String messageId,
      bool isSeen,
      String repliedMessage,
      String repliedTo,
      MessageEnum repliedMessageType,
      List<String> reactions,
      List<String> isSeenBy,
      List<String> deletedBy});
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderUID = null,
    Object? senderName = null,
    Object? senderImage = null,
    Object? message = null,
    Object? messageType = null,
    Object? timeSent = null,
    Object? messageId = null,
    Object? isSeen = null,
    Object? repliedMessage = null,
    Object? repliedTo = null,
    Object? repliedMessageType = null,
    Object? reactions = null,
    Object? isSeenBy = null,
    Object? deletedBy = null,
  }) {
    return _then(_$MessageModelImpl(
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
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
      repliedMessage: null == repliedMessage
          ? _value.repliedMessage
          : repliedMessage // ignore: cast_nullable_to_non_nullable
              as String,
      repliedTo: null == repliedTo
          ? _value.repliedTo
          : repliedTo // ignore: cast_nullable_to_non_nullable
              as String,
      repliedMessageType: null == repliedMessageType
          ? _value.repliedMessageType
          : repliedMessageType // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSeenBy: null == isSeenBy
          ? _value._isSeenBy
          : isSeenBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deletedBy: null == deletedBy
          ? _value._deletedBy
          : deletedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl(
      {required this.senderUID,
      required this.senderName,
      required this.senderImage,
      required this.message,
      required this.messageType,
      @TimestampConverter() required this.timeSent,
      required this.messageId,
      required this.isSeen,
      required this.repliedMessage,
      required this.repliedTo,
      required this.repliedMessageType,
      required final List<String> reactions,
      required final List<String> isSeenBy,
      required final List<String> deletedBy})
      : _reactions = reactions,
        _isSeenBy = isSeenBy,
        _deletedBy = deletedBy;

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String senderUID;
  @override
  final String senderName;
  @override
  final String senderImage;
  @override
  final String message;
  @override
  final MessageEnum messageType;
  @override
  @TimestampConverter()
  final DateTime timeSent;
  @override
  final String messageId;
  @override
  final bool isSeen;
  @override
  final String repliedMessage;
  @override
  final String repliedTo;
  @override
  final MessageEnum repliedMessageType;
  final List<String> _reactions;
  @override
  List<String> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  final List<String> _isSeenBy;
  @override
  List<String> get isSeenBy {
    if (_isSeenBy is EqualUnmodifiableListView) return _isSeenBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_isSeenBy);
  }

  final List<String> _deletedBy;
  @override
  List<String> get deletedBy {
    if (_deletedBy is EqualUnmodifiableListView) return _deletedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deletedBy);
  }

  @override
  String toString() {
    return 'MessageModel(senderUID: $senderUID, senderName: $senderName, senderImage: $senderImage, message: $message, messageType: $messageType, timeSent: $timeSent, messageId: $messageId, isSeen: $isSeen, repliedMessage: $repliedMessage, repliedTo: $repliedTo, repliedMessageType: $repliedMessageType, reactions: $reactions, isSeenBy: $isSeenBy, deletedBy: $deletedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.senderUID, senderUID) || other.senderUID == senderUID) &&
            (identical(other.senderName, senderName) || other.senderName == senderName) &&
            (identical(other.senderImage, senderImage) || other.senderImage == senderImage) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageType, messageType) || other.messageType == messageType) &&
            (identical(other.timeSent, timeSent) || other.timeSent == timeSent) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.isSeen, isSeen) || other.isSeen == isSeen) &&
            (identical(other.repliedMessage, repliedMessage) ||
                other.repliedMessage == repliedMessage) &&
            (identical(other.repliedTo, repliedTo) || other.repliedTo == repliedTo) &&
            (identical(other.repliedMessageType, repliedMessageType) ||
                other.repliedMessageType == repliedMessageType) &&
            const DeepCollectionEquality().equals(other._reactions, _reactions) &&
            const DeepCollectionEquality().equals(other._isSeenBy, _isSeenBy) &&
            const DeepCollectionEquality().equals(other._deletedBy, _deletedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      senderUID,
      senderName,
      senderImage,
      message,
      messageType,
      timeSent,
      messageId,
      isSeen,
      repliedMessage,
      repliedTo,
      repliedMessageType,
      const DeepCollectionEquality().hash(_reactions),
      const DeepCollectionEquality().hash(_isSeenBy),
      const DeepCollectionEquality().hash(_deletedBy));

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(
      this,
    );
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel(
      {required final String senderUID,
      required final String senderName,
      required final String senderImage,
      required final String message,
      required final MessageEnum messageType,
      @TimestampConverter() required final DateTime timeSent,
      required final String messageId,
      required final bool isSeen,
      required final String repliedMessage,
      required final String repliedTo,
      required final MessageEnum repliedMessageType,
      required final List<String> reactions,
      required final List<String> isSeenBy,
      required final List<String> deletedBy}) = _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) = _$MessageModelImpl.fromJson;

  @override
  String get senderUID;
  @override
  String get senderName;
  @override
  String get senderImage;
  @override
  String get message;
  @override
  MessageEnum get messageType;
  @override
  @TimestampConverter()
  DateTime get timeSent;
  @override
  String get messageId;
  @override
  bool get isSeen;
  @override
  String get repliedMessage;
  @override
  String get repliedTo;
  @override
  MessageEnum get repliedMessageType;
  @override
  List<String> get reactions;
  @override
  List<String> get isSeenBy;
  @override
  List<String> get deletedBy;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
