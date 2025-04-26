// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GroupChatState {
  GroupModel get groupDetails => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GroupChatStateCopyWith<GroupChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupChatStateCopyWith<$Res> {
  factory $GroupChatStateCopyWith(
          GroupChatState value, $Res Function(GroupChatState) then) =
      _$GroupChatStateCopyWithImpl<$Res, GroupChatState>;
  @useResult
  $Res call({GroupModel groupDetails, bool isLoading, String? error});

  $GroupModelCopyWith<$Res> get groupDetails;
}

/// @nodoc
class _$GroupChatStateCopyWithImpl<$Res, $Val extends GroupChatState>
    implements $GroupChatStateCopyWith<$Res> {
  _$GroupChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupDetails = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      groupDetails: null == groupDetails
          ? _value.groupDetails
          : groupDetails // ignore: cast_nullable_to_non_nullable
              as GroupModel,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GroupModelCopyWith<$Res> get groupDetails {
    return $GroupModelCopyWith<$Res>(_value.groupDetails, (value) {
      return _then(_value.copyWith(groupDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupChatStateImplCopyWith<$Res>
    implements $GroupChatStateCopyWith<$Res> {
  factory _$$GroupChatStateImplCopyWith(_$GroupChatStateImpl value,
          $Res Function(_$GroupChatStateImpl) then) =
      __$$GroupChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GroupModel groupDetails, bool isLoading, String? error});

  @override
  $GroupModelCopyWith<$Res> get groupDetails;
}

/// @nodoc
class __$$GroupChatStateImplCopyWithImpl<$Res>
    extends _$GroupChatStateCopyWithImpl<$Res, _$GroupChatStateImpl>
    implements _$$GroupChatStateImplCopyWith<$Res> {
  __$$GroupChatStateImplCopyWithImpl(
      _$GroupChatStateImpl _value, $Res Function(_$GroupChatStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupDetails = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$GroupChatStateImpl(
      groupDetails: null == groupDetails
          ? _value.groupDetails
          : groupDetails // ignore: cast_nullable_to_non_nullable
              as GroupModel,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GroupChatStateImpl implements _GroupChatState {
  const _$GroupChatStateImpl(
      {required this.groupDetails,
      required this.isLoading,
      required this.error});

  @override
  final GroupModel groupDetails;
  @override
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'GroupChatState(groupDetails: $groupDetails, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupChatStateImpl &&
            (identical(other.groupDetails, groupDetails) ||
                other.groupDetails == groupDetails) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, groupDetails, isLoading, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupChatStateImplCopyWith<_$GroupChatStateImpl> get copyWith =>
      __$$GroupChatStateImplCopyWithImpl<_$GroupChatStateImpl>(
          this, _$identity);
}

abstract class _GroupChatState implements GroupChatState {
  const factory _GroupChatState(
      {required final GroupModel groupDetails,
      required final bool isLoading,
      required final String? error}) = _$GroupChatStateImpl;

  @override
  GroupModel get groupDetails;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$GroupChatStateImplCopyWith<_$GroupChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
