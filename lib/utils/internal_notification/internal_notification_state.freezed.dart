// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'internal_notification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InternalNotificationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) toast,
    required TResult Function(String message) errorToast,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? toast,
    TResult? Function(String message)? errorToast,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? toast,
    TResult Function(String message)? errorToast,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(ToastState value) toast,
    required TResult Function(FlushBarState value) errorToast,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(ToastState value)? toast,
    TResult? Function(FlushBarState value)? errorToast,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(ToastState value)? toast,
    TResult Function(FlushBarState value)? errorToast,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InternalNotificationStateCopyWith<$Res> {
  factory $InternalNotificationStateCopyWith(InternalNotificationState value,
          $Res Function(InternalNotificationState) then) =
      _$InternalNotificationStateCopyWithImpl<$Res, InternalNotificationState>;
}

/// @nodoc
class _$InternalNotificationStateCopyWithImpl<$Res,
        $Val extends InternalNotificationState>
    implements $InternalNotificationStateCopyWith<$Res> {
  _$InternalNotificationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$InternalNotificationStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl implements Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'InternalNotificationState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) toast,
    required TResult Function(String message) errorToast,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? toast,
    TResult? Function(String message)? errorToast,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? toast,
    TResult Function(String message)? errorToast,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(ToastState value) toast,
    required TResult Function(FlushBarState value) errorToast,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(ToastState value)? toast,
    TResult? Function(FlushBarState value)? errorToast,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(ToastState value)? toast,
    TResult Function(FlushBarState value)? errorToast,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements InternalNotificationState {
  const factory Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$ToastStateImplCopyWith<$Res> {
  factory _$$ToastStateImplCopyWith(
          _$ToastStateImpl value, $Res Function(_$ToastStateImpl) then) =
      __$$ToastStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ToastStateImplCopyWithImpl<$Res>
    extends _$InternalNotificationStateCopyWithImpl<$Res, _$ToastStateImpl>
    implements _$$ToastStateImplCopyWith<$Res> {
  __$$ToastStateImplCopyWithImpl(
      _$ToastStateImpl _value, $Res Function(_$ToastStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ToastStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ToastStateImpl implements ToastState {
  const _$ToastStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'InternalNotificationState.toast(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToastStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToastStateImplCopyWith<_$ToastStateImpl> get copyWith =>
      __$$ToastStateImplCopyWithImpl<_$ToastStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) toast,
    required TResult Function(String message) errorToast,
  }) {
    return toast(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? toast,
    TResult? Function(String message)? errorToast,
  }) {
    return toast?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? toast,
    TResult Function(String message)? errorToast,
    required TResult orElse(),
  }) {
    if (toast != null) {
      return toast(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(ToastState value) toast,
    required TResult Function(FlushBarState value) errorToast,
  }) {
    return toast(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(ToastState value)? toast,
    TResult? Function(FlushBarState value)? errorToast,
  }) {
    return toast?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(ToastState value)? toast,
    TResult Function(FlushBarState value)? errorToast,
    required TResult orElse(),
  }) {
    if (toast != null) {
      return toast(this);
    }
    return orElse();
  }
}

abstract class ToastState implements InternalNotificationState {
  const factory ToastState(final String message) = _$ToastStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ToastStateImplCopyWith<_$ToastStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FlushBarStateImplCopyWith<$Res> {
  factory _$$FlushBarStateImplCopyWith(
          _$FlushBarStateImpl value, $Res Function(_$FlushBarStateImpl) then) =
      __$$FlushBarStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FlushBarStateImplCopyWithImpl<$Res>
    extends _$InternalNotificationStateCopyWithImpl<$Res, _$FlushBarStateImpl>
    implements _$$FlushBarStateImplCopyWith<$Res> {
  __$$FlushBarStateImplCopyWithImpl(
      _$FlushBarStateImpl _value, $Res Function(_$FlushBarStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$FlushBarStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FlushBarStateImpl implements FlushBarState {
  const _$FlushBarStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'InternalNotificationState.errorToast(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlushBarStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FlushBarStateImplCopyWith<_$FlushBarStateImpl> get copyWith =>
      __$$FlushBarStateImplCopyWithImpl<_$FlushBarStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String message) toast,
    required TResult Function(String message) errorToast,
  }) {
    return errorToast(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String message)? toast,
    TResult? Function(String message)? errorToast,
  }) {
    return errorToast?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String message)? toast,
    TResult Function(String message)? errorToast,
    required TResult orElse(),
  }) {
    if (errorToast != null) {
      return errorToast(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(ToastState value) toast,
    required TResult Function(FlushBarState value) errorToast,
  }) {
    return errorToast(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(ToastState value)? toast,
    TResult? Function(FlushBarState value)? errorToast,
  }) {
    return errorToast?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(ToastState value)? toast,
    TResult Function(FlushBarState value)? errorToast,
    required TResult orElse(),
  }) {
    if (errorToast != null) {
      return errorToast(this);
    }
    return orElse();
  }
}

abstract class FlushBarState implements InternalNotificationState {
  const factory FlushBarState(final String message) = _$FlushBarStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$FlushBarStateImplCopyWith<_$FlushBarStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
