// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcours_cluster_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ParcoursClusterItem {
  String get id => throw _privateConstructorUsedError;
  LatLng get position => throw _privateConstructorUsedError;
  BitmapDescriptor get icon => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get snippet => throw _privateConstructorUsedError;
  List<LatLng> get allPoints => throw _privateConstructorUsedError;

  /// Create a copy of ParcoursClusterItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParcoursClusterItemCopyWith<ParcoursClusterItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParcoursClusterItemCopyWith<$Res> {
  factory $ParcoursClusterItemCopyWith(
          ParcoursClusterItem value, $Res Function(ParcoursClusterItem) then) =
      _$ParcoursClusterItemCopyWithImpl<$Res, ParcoursClusterItem>;
  @useResult
  $Res call(
      {String id,
      LatLng position,
      BitmapDescriptor icon,
      String title,
      String snippet,
      List<LatLng> allPoints});
}

/// @nodoc
class _$ParcoursClusterItemCopyWithImpl<$Res, $Val extends ParcoursClusterItem>
    implements $ParcoursClusterItemCopyWith<$Res> {
  _$ParcoursClusterItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParcoursClusterItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? icon = null,
    Object? title = null,
    Object? snippet = null,
    Object? allPoints = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as LatLng,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as BitmapDescriptor,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      snippet: null == snippet
          ? _value.snippet
          : snippet // ignore: cast_nullable_to_non_nullable
              as String,
      allPoints: null == allPoints
          ? _value.allPoints
          : allPoints // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParcoursClusterItemImplCopyWith<$Res>
    implements $ParcoursClusterItemCopyWith<$Res> {
  factory _$$ParcoursClusterItemImplCopyWith(
          _$ParcoursClusterItemImpl value, $Res Function(_$ParcoursClusterItemImpl) then) =
      __$$ParcoursClusterItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      LatLng position,
      BitmapDescriptor icon,
      String title,
      String snippet,
      List<LatLng> allPoints});
}

/// @nodoc
class __$$ParcoursClusterItemImplCopyWithImpl<$Res>
    extends _$ParcoursClusterItemCopyWithImpl<$Res, _$ParcoursClusterItemImpl>
    implements _$$ParcoursClusterItemImplCopyWith<$Res> {
  __$$ParcoursClusterItemImplCopyWithImpl(
      _$ParcoursClusterItemImpl _value, $Res Function(_$ParcoursClusterItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParcoursClusterItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? icon = null,
    Object? title = null,
    Object? snippet = null,
    Object? allPoints = null,
  }) {
    return _then(_$ParcoursClusterItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as LatLng,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as BitmapDescriptor,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      snippet: null == snippet
          ? _value.snippet
          : snippet // ignore: cast_nullable_to_non_nullable
              as String,
      allPoints: null == allPoints
          ? _value._allPoints
          : allPoints // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
    ));
  }
}

/// @nodoc

class _$ParcoursClusterItemImpl extends _ParcoursClusterItem {
  const _$ParcoursClusterItemImpl(
      {required this.id,
      required this.position,
      required this.icon,
      required this.title,
      required this.snippet,
      required final List<LatLng> allPoints})
      : _allPoints = allPoints,
        super._();

  @override
  final String id;
  @override
  final LatLng position;
  @override
  final BitmapDescriptor icon;
  @override
  final String title;
  @override
  final String snippet;
  final List<LatLng> _allPoints;
  @override
  List<LatLng> get allPoints {
    if (_allPoints is EqualUnmodifiableListView) return _allPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allPoints);
  }

  @override
  String toString() {
    return 'ParcoursClusterItem(id: $id, position: $position, icon: $icon, title: $title, snippet: $snippet, allPoints: $allPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParcoursClusterItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.position, position) || other.position == position) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.snippet, snippet) || other.snippet == snippet) &&
            const DeepCollectionEquality().equals(other._allPoints, _allPoints));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, position, icon, title, snippet,
      const DeepCollectionEquality().hash(_allPoints));

  /// Create a copy of ParcoursClusterItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParcoursClusterItemImplCopyWith<_$ParcoursClusterItemImpl> get copyWith =>
      __$$ParcoursClusterItemImplCopyWithImpl<_$ParcoursClusterItemImpl>(this, _$identity);
}

abstract class _ParcoursClusterItem extends ParcoursClusterItem {
  const factory _ParcoursClusterItem(
      {required final String id,
      required final LatLng position,
      required final BitmapDescriptor icon,
      required final String title,
      required final String snippet,
      required final List<LatLng> allPoints}) = _$ParcoursClusterItemImpl;
  const _ParcoursClusterItem._() : super._();

  @override
  String get id;
  @override
  LatLng get position;
  @override
  BitmapDescriptor get icon;
  @override
  String get title;
  @override
  String get snippet;
  @override
  List<LatLng> get allPoints;

  /// Create a copy of ParcoursClusterItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParcoursClusterItemImplCopyWith<_$ParcoursClusterItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
