// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  bool get isMenuOpen => throw _privateConstructorUsedError;
  bool get trafficEnabled => throw _privateConstructorUsedError;
  MapType get mapType => throw _privateConstructorUsedError;
  bool get showClusterDialog => throw _privateConstructorUsedError;
  bool get parcourOverlayVisible => throw _privateConstructorUsedError;
  ParcoursWithGPSData? get selectedParcour => throw _privateConstructorUsedError;
  Set<ParcoursWithGPSData>? get clusterItems => throw _privateConstructorUsedError;
  CameraPosition? get lastCameraPosition => throw _privateConstructorUsedError;
  String? get selectedFilter => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {bool isMenuOpen,
      bool trafficEnabled,
      MapType mapType,
      bool showClusterDialog,
      bool parcourOverlayVisible,
      ParcoursWithGPSData? selectedParcour,
      Set<ParcoursWithGPSData>? clusterItems,
      CameraPosition? lastCameraPosition,
      String? selectedFilter});

  $ParcoursWithGPSDataCopyWith<$Res>? get selectedParcour;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState> implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMenuOpen = null,
    Object? trafficEnabled = null,
    Object? mapType = null,
    Object? showClusterDialog = null,
    Object? parcourOverlayVisible = null,
    Object? selectedParcour = freezed,
    Object? clusterItems = freezed,
    Object? lastCameraPosition = freezed,
    Object? selectedFilter = freezed,
  }) {
    return _then(_value.copyWith(
      isMenuOpen: null == isMenuOpen
          ? _value.isMenuOpen
          : isMenuOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      trafficEnabled: null == trafficEnabled
          ? _value.trafficEnabled
          : trafficEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mapType: null == mapType
          ? _value.mapType
          : mapType // ignore: cast_nullable_to_non_nullable
              as MapType,
      showClusterDialog: null == showClusterDialog
          ? _value.showClusterDialog
          : showClusterDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      parcourOverlayVisible: null == parcourOverlayVisible
          ? _value.parcourOverlayVisible
          : parcourOverlayVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedParcour: freezed == selectedParcour
          ? _value.selectedParcour
          : selectedParcour // ignore: cast_nullable_to_non_nullable
              as ParcoursWithGPSData?,
      clusterItems: freezed == clusterItems
          ? _value.clusterItems
          : clusterItems // ignore: cast_nullable_to_non_nullable
              as Set<ParcoursWithGPSData>?,
      lastCameraPosition: freezed == lastCameraPosition
          ? _value.lastCameraPosition
          : lastCameraPosition // ignore: cast_nullable_to_non_nullable
              as CameraPosition?,
      selectedFilter: freezed == selectedFilter
          ? _value.selectedFilter
          : selectedFilter // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParcoursWithGPSDataCopyWith<$Res>? get selectedParcour {
    if (_value.selectedParcour == null) {
      return null;
    }

    return $ParcoursWithGPSDataCopyWith<$Res>(_value.selectedParcour!, (value) {
      return _then(_value.copyWith(selectedParcour: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(_$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isMenuOpen,
      bool trafficEnabled,
      MapType mapType,
      bool showClusterDialog,
      bool parcourOverlayVisible,
      ParcoursWithGPSData? selectedParcour,
      Set<ParcoursWithGPSData>? clusterItems,
      CameraPosition? lastCameraPosition,
      String? selectedFilter});

  @override
  $ParcoursWithGPSDataCopyWith<$Res>? get selectedParcour;
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res> extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(_$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMenuOpen = null,
    Object? trafficEnabled = null,
    Object? mapType = null,
    Object? showClusterDialog = null,
    Object? parcourOverlayVisible = null,
    Object? selectedParcour = freezed,
    Object? clusterItems = freezed,
    Object? lastCameraPosition = freezed,
    Object? selectedFilter = freezed,
  }) {
    return _then(_$HomeStateImpl(
      isMenuOpen: null == isMenuOpen
          ? _value.isMenuOpen
          : isMenuOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      trafficEnabled: null == trafficEnabled
          ? _value.trafficEnabled
          : trafficEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mapType: null == mapType
          ? _value.mapType
          : mapType // ignore: cast_nullable_to_non_nullable
              as MapType,
      showClusterDialog: null == showClusterDialog
          ? _value.showClusterDialog
          : showClusterDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      parcourOverlayVisible: null == parcourOverlayVisible
          ? _value.parcourOverlayVisible
          : parcourOverlayVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedParcour: freezed == selectedParcour
          ? _value.selectedParcour
          : selectedParcour // ignore: cast_nullable_to_non_nullable
              as ParcoursWithGPSData?,
      clusterItems: freezed == clusterItems
          ? _value._clusterItems
          : clusterItems // ignore: cast_nullable_to_non_nullable
              as Set<ParcoursWithGPSData>?,
      lastCameraPosition: freezed == lastCameraPosition
          ? _value.lastCameraPosition
          : lastCameraPosition // ignore: cast_nullable_to_non_nullable
              as CameraPosition?,
      selectedFilter: freezed == selectedFilter
          ? _value.selectedFilter
          : selectedFilter // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {this.isMenuOpen = false,
      this.trafficEnabled = false,
      this.mapType = MapType.normal,
      this.showClusterDialog = false,
      this.parcourOverlayVisible = false,
      this.selectedParcour,
      final Set<ParcoursWithGPSData>? clusterItems,
      this.lastCameraPosition,
      this.selectedFilter})
      : _clusterItems = clusterItems;

  @override
  @JsonKey()
  final bool isMenuOpen;
  @override
  @JsonKey()
  final bool trafficEnabled;
  @override
  @JsonKey()
  final MapType mapType;
  @override
  @JsonKey()
  final bool showClusterDialog;
  @override
  @JsonKey()
  final bool parcourOverlayVisible;
  @override
  final ParcoursWithGPSData? selectedParcour;
  final Set<ParcoursWithGPSData>? _clusterItems;
  @override
  Set<ParcoursWithGPSData>? get clusterItems {
    final value = _clusterItems;
    if (value == null) return null;
    if (_clusterItems is EqualUnmodifiableSetView) return _clusterItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  @override
  final CameraPosition? lastCameraPosition;
  @override
  final String? selectedFilter;

  @override
  String toString() {
    return 'HomeState(isMenuOpen: $isMenuOpen, trafficEnabled: $trafficEnabled, mapType: $mapType, showClusterDialog: $showClusterDialog, parcourOverlayVisible: $parcourOverlayVisible, selectedParcour: $selectedParcour, clusterItems: $clusterItems, lastCameraPosition: $lastCameraPosition, selectedFilter: $selectedFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.isMenuOpen, isMenuOpen) || other.isMenuOpen == isMenuOpen) &&
            (identical(other.trafficEnabled, trafficEnabled) ||
                other.trafficEnabled == trafficEnabled) &&
            (identical(other.mapType, mapType) || other.mapType == mapType) &&
            (identical(other.showClusterDialog, showClusterDialog) ||
                other.showClusterDialog == showClusterDialog) &&
            (identical(other.parcourOverlayVisible, parcourOverlayVisible) ||
                other.parcourOverlayVisible == parcourOverlayVisible) &&
            (identical(other.selectedParcour, selectedParcour) ||
                other.selectedParcour == selectedParcour) &&
            const DeepCollectionEquality().equals(other._clusterItems, _clusterItems) &&
            (identical(other.lastCameraPosition, lastCameraPosition) ||
                other.lastCameraPosition == lastCameraPosition) &&
            (identical(other.selectedFilter, selectedFilter) ||
                other.selectedFilter == selectedFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isMenuOpen,
      trafficEnabled,
      mapType,
      showClusterDialog,
      parcourOverlayVisible,
      selectedParcour,
      const DeepCollectionEquality().hash(_clusterItems),
      lastCameraPosition,
      selectedFilter);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {final bool isMenuOpen,
      final bool trafficEnabled,
      final MapType mapType,
      final bool showClusterDialog,
      final bool parcourOverlayVisible,
      final ParcoursWithGPSData? selectedParcour,
      final Set<ParcoursWithGPSData>? clusterItems,
      final CameraPosition? lastCameraPosition,
      final String? selectedFilter}) = _$HomeStateImpl;

  @override
  bool get isMenuOpen;
  @override
  bool get trafficEnabled;
  @override
  MapType get mapType;
  @override
  bool get showClusterDialog;
  @override
  bool get parcourOverlayVisible;
  @override
  ParcoursWithGPSData? get selectedParcour;
  @override
  Set<ParcoursWithGPSData>? get clusterItems;
  @override
  CameraPosition? get lastCameraPosition;
  @override
  String? get selectedFilter;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith => throw _privateConstructorUsedError;
}
