// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  MapType get mapType => throw _privateConstructorUsedError;
  bool get trafficEnabled => throw _privateConstructorUsedError;
  bool get isMenuOpen => throw _privateConstructorUsedError;
  ParcoursWithGPSData? get selectedParcour =>
      throw _privateConstructorUsedError;
  bool get parcourOverlayVisible => throw _privateConstructorUsedError;
  String? get selectedFilter => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {MapType mapType,
      bool trafficEnabled,
      bool isMenuOpen,
      ParcoursWithGPSData? selectedParcour,
      bool parcourOverlayVisible,
      String? selectedFilter});

  $ParcoursWithGPSDataCopyWith<$Res>? get selectedParcour;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapType = null,
    Object? trafficEnabled = null,
    Object? isMenuOpen = null,
    Object? selectedParcour = freezed,
    Object? parcourOverlayVisible = null,
    Object? selectedFilter = freezed,
  }) {
    return _then(_value.copyWith(
      mapType: null == mapType
          ? _value.mapType
          : mapType // ignore: cast_nullable_to_non_nullable
              as MapType,
      trafficEnabled: null == trafficEnabled
          ? _value.trafficEnabled
          : trafficEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isMenuOpen: null == isMenuOpen
          ? _value.isMenuOpen
          : isMenuOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedParcour: freezed == selectedParcour
          ? _value.selectedParcour
          : selectedParcour // ignore: cast_nullable_to_non_nullable
              as ParcoursWithGPSData?,
      parcourOverlayVisible: null == parcourOverlayVisible
          ? _value.parcourOverlayVisible
          : parcourOverlayVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedFilter: freezed == selectedFilter
          ? _value.selectedFilter
          : selectedFilter // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

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
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MapType mapType,
      bool trafficEnabled,
      bool isMenuOpen,
      ParcoursWithGPSData? selectedParcour,
      bool parcourOverlayVisible,
      String? selectedFilter});

  @override
  $ParcoursWithGPSDataCopyWith<$Res>? get selectedParcour;
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapType = null,
    Object? trafficEnabled = null,
    Object? isMenuOpen = null,
    Object? selectedParcour = freezed,
    Object? parcourOverlayVisible = null,
    Object? selectedFilter = freezed,
  }) {
    return _then(_$HomeStateImpl(
      mapType: null == mapType
          ? _value.mapType
          : mapType // ignore: cast_nullable_to_non_nullable
              as MapType,
      trafficEnabled: null == trafficEnabled
          ? _value.trafficEnabled
          : trafficEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isMenuOpen: null == isMenuOpen
          ? _value.isMenuOpen
          : isMenuOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedParcour: freezed == selectedParcour
          ? _value.selectedParcour
          : selectedParcour // ignore: cast_nullable_to_non_nullable
              as ParcoursWithGPSData?,
      parcourOverlayVisible: null == parcourOverlayVisible
          ? _value.parcourOverlayVisible
          : parcourOverlayVisible // ignore: cast_nullable_to_non_nullable
              as bool,
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
      {this.mapType = MapType.normal,
      this.trafficEnabled = false,
      this.isMenuOpen = false,
      this.selectedParcour,
      this.parcourOverlayVisible = false,
      this.selectedFilter});

  @override
  @JsonKey()
  final MapType mapType;
  @override
  @JsonKey()
  final bool trafficEnabled;
  @override
  @JsonKey()
  final bool isMenuOpen;
  @override
  final ParcoursWithGPSData? selectedParcour;
  @override
  @JsonKey()
  final bool parcourOverlayVisible;
  @override
  final String? selectedFilter;

  @override
  String toString() {
    return 'HomeState(mapType: $mapType, trafficEnabled: $trafficEnabled, isMenuOpen: $isMenuOpen, selectedParcour: $selectedParcour, parcourOverlayVisible: $parcourOverlayVisible, selectedFilter: $selectedFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.mapType, mapType) || other.mapType == mapType) &&
            (identical(other.trafficEnabled, trafficEnabled) ||
                other.trafficEnabled == trafficEnabled) &&
            (identical(other.isMenuOpen, isMenuOpen) ||
                other.isMenuOpen == isMenuOpen) &&
            (identical(other.selectedParcour, selectedParcour) ||
                other.selectedParcour == selectedParcour) &&
            (identical(other.parcourOverlayVisible, parcourOverlayVisible) ||
                other.parcourOverlayVisible == parcourOverlayVisible) &&
            (identical(other.selectedFilter, selectedFilter) ||
                other.selectedFilter == selectedFilter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mapType, trafficEnabled,
      isMenuOpen, selectedParcour, parcourOverlayVisible, selectedFilter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {final MapType mapType,
      final bool trafficEnabled,
      final bool isMenuOpen,
      final ParcoursWithGPSData? selectedParcour,
      final bool parcourOverlayVisible,
      final String? selectedFilter}) = _$HomeStateImpl;

  @override
  MapType get mapType;
  @override
  bool get trafficEnabled;
  @override
  bool get isMenuOpen;
  @override
  ParcoursWithGPSData? get selectedParcour;
  @override
  bool get parcourOverlayVisible;
  @override
  String? get selectedFilter;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
