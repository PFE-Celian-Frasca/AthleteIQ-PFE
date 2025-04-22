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
  String? get id => throw _privateConstructorUsedError;
  String get admin => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  String? get groupIcon => throw _privateConstructorUsedError;
  List<String> get members => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get recentMessage => throw _privateConstructorUsedError;
  String? get recentMessageSender => throw _privateConstructorUsedError;
  DateTime? get recentMessageTime => throw _privateConstructorUsedError;

  /// Serializes this GroupModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {String? id,
      String admin,
      String groupName,
      String? groupIcon,
      List<String> members,
      String type,
      String? recentMessage,
      String? recentMessageSender,
      DateTime? recentMessageTime});
}

/// @nodoc
class _$GroupModelCopyWithImpl<$Res, $Val extends GroupModel>
    implements $GroupModelCopyWith<$Res> {
  _$GroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? admin = null,
    Object? groupName = null,
    Object? groupIcon = freezed,
    Object? members = null,
    Object? type = null,
    Object? recentMessage = freezed,
    Object? recentMessageSender = freezed,
    Object? recentMessageTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      admin: null == admin
          ? _value.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      groupIcon: freezed == groupIcon
          ? _value.groupIcon
          : groupIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      recentMessage: freezed == recentMessage
          ? _value.recentMessage
          : recentMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      recentMessageSender: freezed == recentMessageSender
          ? _value.recentMessageSender
          : recentMessageSender // ignore: cast_nullable_to_non_nullable
              as String?,
      recentMessageTime: freezed == recentMessageTime
          ? _value.recentMessageTime
          : recentMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      {String? id,
      String admin,
      String groupName,
      String? groupIcon,
      List<String> members,
      String type,
      String? recentMessage,
      String? recentMessageSender,
      DateTime? recentMessageTime});
}

/// @nodoc
class __$$GroupModelImplCopyWithImpl<$Res>
    extends _$GroupModelCopyWithImpl<$Res, _$GroupModelImpl>
    implements _$$GroupModelImplCopyWith<$Res> {
  __$$GroupModelImplCopyWithImpl(
      _$GroupModelImpl _value, $Res Function(_$GroupModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? admin = null,
    Object? groupName = null,
    Object? groupIcon = freezed,
    Object? members = null,
    Object? type = null,
    Object? recentMessage = freezed,
    Object? recentMessageSender = freezed,
    Object? recentMessageTime = freezed,
  }) {
    return _then(_$GroupModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      admin: null == admin
          ? _value.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      groupIcon: freezed == groupIcon
          ? _value.groupIcon
          : groupIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      recentMessage: freezed == recentMessage
          ? _value.recentMessage
          : recentMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      recentMessageSender: freezed == recentMessageSender
          ? _value.recentMessageSender
          : recentMessageSender // ignore: cast_nullable_to_non_nullable
              as String?,
      recentMessageTime: freezed == recentMessageTime
          ? _value.recentMessageTime
          : recentMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupModelImpl with DiagnosticableTreeMixin implements _GroupModel {
  const _$GroupModelImpl(
      {this.id,
      required this.admin,
      required this.groupName,
      this.groupIcon,
      final List<String> members = const [],
      this.type = 'public',
      this.recentMessage = '',
      this.recentMessageSender,
      this.recentMessageTime})
      : _members = members;

  factory _$GroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String admin;
  @override
  final String groupName;
  @override
  final String? groupIcon;
  final List<String> _members;
  @override
  @JsonKey()
  List<String> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String? recentMessage;
  @override
  final String? recentMessageSender;
  @override
  final DateTime? recentMessageTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GroupModel(id: $id, admin: $admin, groupName: $groupName, groupIcon: $groupIcon, members: $members, type: $type, recentMessage: $recentMessage, recentMessageSender: $recentMessageSender, recentMessageTime: $recentMessageTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GroupModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('admin', admin))
      ..add(DiagnosticsProperty('groupName', groupName))
      ..add(DiagnosticsProperty('groupIcon', groupIcon))
      ..add(DiagnosticsProperty('members', members))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('recentMessage', recentMessage))
      ..add(DiagnosticsProperty('recentMessageSender', recentMessageSender))
      ..add(DiagnosticsProperty('recentMessageTime', recentMessageTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.admin, admin) || other.admin == admin) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.groupIcon, groupIcon) ||
                other.groupIcon == groupIcon) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.recentMessage, recentMessage) ||
                other.recentMessage == recentMessage) &&
            (identical(other.recentMessageSender, recentMessageSender) ||
                other.recentMessageSender == recentMessageSender) &&
            (identical(other.recentMessageTime, recentMessageTime) ||
                other.recentMessageTime == recentMessageTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      admin,
      groupName,
      groupIcon,
      const DeepCollectionEquality().hash(_members),
      type,
      recentMessage,
      recentMessageSender,
      recentMessageTime);

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {final String? id,
      required final String admin,
      required final String groupName,
      final String? groupIcon,
      final List<String> members,
      final String type,
      final String? recentMessage,
      final String? recentMessageSender,
      final DateTime? recentMessageTime}) = _$GroupModelImpl;

  factory _GroupModel.fromJson(Map<String, dynamic> json) =
      _$GroupModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get admin;
  @override
  String get groupName;
  @override
  String? get groupIcon;
  @override
  List<String> get members;
  @override
  String get type;
  @override
  String? get recentMessage;
  @override
  String? get recentMessageSender;
  @override
  DateTime? get recentMessageTime;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupModelImplCopyWith<_$GroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
