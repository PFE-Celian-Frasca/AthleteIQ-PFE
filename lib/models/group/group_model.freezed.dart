// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) {
  return _GroupModel.fromJson(json);
}

/// @nodoc
mixin _$GroupModel {
  String get creatorUID => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  String get groupDescription => throw _privateConstructorUsedError;
  String get groupImage => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  String get senderUID => throw _privateConstructorUsedError;
  MessageEnum get messageType => throw _privateConstructorUsedError;
  String get messageId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get timeSent => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  bool get editSettings => throw _privateConstructorUsedError;
  List<String> get membersUIDs => throw _privateConstructorUsedError;
  List<String> get adminsUIDs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupModelCopyWith<GroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupModelCopyWith<$Res> {
  factory $GroupModelCopyWith(
          GroupModel value, $Res Function(GroupModel) then) =
      _$GroupModelCopyWithImpl<$Res, GroupModel>;
  @useResult
  $Res call(
      {String creatorUID,
      String groupName,
      String groupDescription,
      String groupImage,
      String groupId,
      String lastMessage,
      String senderUID,
      MessageEnum messageType,
      String messageId,
      @TimestampConverter() DateTime timeSent,
      @TimestampConverter() DateTime createdAt,
      bool isPrivate,
      bool editSettings,
      List<String> membersUIDs,
      List<String> adminsUIDs});
}

/// @nodoc
class _$GroupModelCopyWithImpl<$Res, $Val extends GroupModel>
    implements $GroupModelCopyWith<$Res> {
  _$GroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creatorUID = null,
    Object? groupName = null,
    Object? groupDescription = null,
    Object? groupImage = null,
    Object? groupId = null,
    Object? lastMessage = null,
    Object? senderUID = null,
    Object? messageType = null,
    Object? messageId = null,
    Object? timeSent = null,
    Object? createdAt = null,
    Object? isPrivate = null,
    Object? editSettings = null,
    Object? membersUIDs = null,
    Object? adminsUIDs = null,
  }) {
    return _then(_value.copyWith(
      creatorUID: null == creatorUID
          ? _value.creatorUID
          : creatorUID // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      groupDescription: null == groupDescription
          ? _value.groupDescription
          : groupDescription // ignore: cast_nullable_to_non_nullable
              as String,
      groupImage: null == groupImage
          ? _value.groupImage
          : groupImage // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      senderUID: null == senderUID
          ? _value.senderUID
          : senderUID // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      editSettings: null == editSettings
          ? _value.editSettings
          : editSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      membersUIDs: null == membersUIDs
          ? _value.membersUIDs
          : membersUIDs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adminsUIDs: null == adminsUIDs
          ? _value.adminsUIDs
          : adminsUIDs // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupModelImplCopyWith<$Res>
    implements $GroupModelCopyWith<$Res> {
  factory _$$GroupModelImplCopyWith(
          _$GroupModelImpl value, $Res Function(_$GroupModelImpl) then) =
      __$$GroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String creatorUID,
      String groupName,
      String groupDescription,
      String groupImage,
      String groupId,
      String lastMessage,
      String senderUID,
      MessageEnum messageType,
      String messageId,
      @TimestampConverter() DateTime timeSent,
      @TimestampConverter() DateTime createdAt,
      bool isPrivate,
      bool editSettings,
      List<String> membersUIDs,
      List<String> adminsUIDs});
}

/// @nodoc
class __$$GroupModelImplCopyWithImpl<$Res>
    extends _$GroupModelCopyWithImpl<$Res, _$GroupModelImpl>
    implements _$$GroupModelImplCopyWith<$Res> {
  __$$GroupModelImplCopyWithImpl(
      _$GroupModelImpl _value, $Res Function(_$GroupModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creatorUID = null,
    Object? groupName = null,
    Object? groupDescription = null,
    Object? groupImage = null,
    Object? groupId = null,
    Object? lastMessage = null,
    Object? senderUID = null,
    Object? messageType = null,
    Object? messageId = null,
    Object? timeSent = null,
    Object? createdAt = null,
    Object? isPrivate = null,
    Object? editSettings = null,
    Object? membersUIDs = null,
    Object? adminsUIDs = null,
  }) {
    return _then(_$GroupModelImpl(
      creatorUID: null == creatorUID
          ? _value.creatorUID
          : creatorUID // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      groupDescription: null == groupDescription
          ? _value.groupDescription
          : groupDescription // ignore: cast_nullable_to_non_nullable
              as String,
      groupImage: null == groupImage
          ? _value.groupImage
          : groupImage // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      senderUID: null == senderUID
          ? _value.senderUID
          : senderUID // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      editSettings: null == editSettings
          ? _value.editSettings
          : editSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      membersUIDs: null == membersUIDs
          ? _value._membersUIDs
          : membersUIDs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adminsUIDs: null == adminsUIDs
          ? _value._adminsUIDs
          : adminsUIDs // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupModelImpl with DiagnosticableTreeMixin implements _GroupModel {
  const _$GroupModelImpl(
      {required this.creatorUID,
      required this.groupName,
      required this.groupDescription,
      required this.groupImage,
      required this.groupId,
      required this.lastMessage,
      required this.senderUID,
      required this.messageType,
      required this.messageId,
      @TimestampConverter() required this.timeSent,
      @TimestampConverter() required this.createdAt,
      required this.isPrivate,
      required this.editSettings,
      required final List<String> membersUIDs,
      required final List<String> adminsUIDs})
      : _membersUIDs = membersUIDs,
        _adminsUIDs = adminsUIDs;

  factory _$GroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupModelImplFromJson(json);

  @override
  final String creatorUID;
  @override
  final String groupName;
  @override
  final String groupDescription;
  @override
  final String groupImage;
  @override
  final String groupId;
  @override
  final String lastMessage;
  @override
  final String senderUID;
  @override
  final MessageEnum messageType;
  @override
  final String messageId;
  @override
  @TimestampConverter()
  final DateTime timeSent;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  final bool isPrivate;
  @override
  final bool editSettings;
  final List<String> _membersUIDs;
  @override
  List<String> get membersUIDs {
    if (_membersUIDs is EqualUnmodifiableListView) return _membersUIDs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_membersUIDs);
  }

  final List<String> _adminsUIDs;
  @override
  List<String> get adminsUIDs {
    if (_adminsUIDs is EqualUnmodifiableListView) return _adminsUIDs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adminsUIDs);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GroupModel(creatorUID: $creatorUID, groupName: $groupName, groupDescription: $groupDescription, groupImage: $groupImage, groupId: $groupId, lastMessage: $lastMessage, senderUID: $senderUID, messageType: $messageType, messageId: $messageId, timeSent: $timeSent, createdAt: $createdAt, isPrivate: $isPrivate, editSettings: $editSettings, membersUIDs: $membersUIDs, adminsUIDs: $adminsUIDs)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GroupModel'))
      ..add(DiagnosticsProperty('creatorUID', creatorUID))
      ..add(DiagnosticsProperty('groupName', groupName))
      ..add(DiagnosticsProperty('groupDescription', groupDescription))
      ..add(DiagnosticsProperty('groupImage', groupImage))
      ..add(DiagnosticsProperty('groupId', groupId))
      ..add(DiagnosticsProperty('lastMessage', lastMessage))
      ..add(DiagnosticsProperty('senderUID', senderUID))
      ..add(DiagnosticsProperty('messageType', messageType))
      ..add(DiagnosticsProperty('messageId', messageId))
      ..add(DiagnosticsProperty('timeSent', timeSent))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('isPrivate', isPrivate))
      ..add(DiagnosticsProperty('editSettings', editSettings))
      ..add(DiagnosticsProperty('membersUIDs', membersUIDs))
      ..add(DiagnosticsProperty('adminsUIDs', adminsUIDs));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupModelImpl &&
            (identical(other.creatorUID, creatorUID) ||
                other.creatorUID == creatorUID) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.groupDescription, groupDescription) ||
                other.groupDescription == groupDescription) &&
            (identical(other.groupImage, groupImage) ||
                other.groupImage == groupImage) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.senderUID, senderUID) ||
                other.senderUID == senderUID) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.timeSent, timeSent) ||
                other.timeSent == timeSent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.editSettings, editSettings) ||
                other.editSettings == editSettings) &&
            const DeepCollectionEquality()
                .equals(other._membersUIDs, _membersUIDs) &&
            const DeepCollectionEquality()
                .equals(other._adminsUIDs, _adminsUIDs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      creatorUID,
      groupName,
      groupDescription,
      groupImage,
      groupId,
      lastMessage,
      senderUID,
      messageType,
      messageId,
      timeSent,
      createdAt,
      isPrivate,
      editSettings,
      const DeepCollectionEquality().hash(_membersUIDs),
      const DeepCollectionEquality().hash(_adminsUIDs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupModelImplCopyWith<_$GroupModelImpl> get copyWith =>
      __$$GroupModelImplCopyWithImpl<_$GroupModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupModelImplToJson(
      this,
    );
  }
}

abstract class _GroupModel implements GroupModel {
  const factory _GroupModel(
      {required final String creatorUID,
      required final String groupName,
      required final String groupDescription,
      required final String groupImage,
      required final String groupId,
      required final String lastMessage,
      required final String senderUID,
      required final MessageEnum messageType,
      required final String messageId,
      @TimestampConverter() required final DateTime timeSent,
      @TimestampConverter() required final DateTime createdAt,
      required final bool isPrivate,
      required final bool editSettings,
      required final List<String> membersUIDs,
      required final List<String> adminsUIDs}) = _$GroupModelImpl;

  factory _GroupModel.fromJson(Map<String, dynamic> json) =
      _$GroupModelImpl.fromJson;

  @override
  String get creatorUID;
  @override
  String get groupName;
  @override
  String get groupDescription;
  @override
  String get groupImage;
  @override
  String get groupId;
  @override
  String get lastMessage;
  @override
  String get senderUID;
  @override
  MessageEnum get messageType;
  @override
  String get messageId;
  @override
  @TimestampConverter()
  DateTime get timeSent;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  bool get isPrivate;
  @override
  bool get editSettings;
  @override
  List<String> get membersUIDs;
  @override
  List<String> get adminsUIDs;
  @override
  @JsonKey(ignore: true)
  _$$GroupModelImplCopyWith<_$GroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
