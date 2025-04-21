import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'cluster_state.freezed.dart';

@freezed
class ClusterState with _$ClusterState {
  const factory ClusterState({
    @Default(<Marker>{}) Set<Marker> markers,
    @Default(<Polyline>{}) Set<Polyline> polylines,
    bool? isLoading,
    String? error,
  }) = _ClusterState;

  factory ClusterState.initial() => const ClusterState(
        markers: {},
        polylines: {},
        isLoading: false,
      );
}
