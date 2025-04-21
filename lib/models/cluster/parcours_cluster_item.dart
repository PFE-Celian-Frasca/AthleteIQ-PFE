import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';

part 'parcours_cluster_item.freezed.dart';

@freezed
class ParcoursClusterItem with _$ParcoursClusterItem implements ClusterItem {
  const factory ParcoursClusterItem({
    required String id,
    required LatLng position,
    required BitmapDescriptor icon,
    required String title,
    required String snippet,
    required List<LatLng> allPoints,
  }) = _ParcoursClusterItem;

  const ParcoursClusterItem._();

  @override
  LatLng get location => position;

  @override
  String get geohash => Geohash.encode(latLng: position, codeLength: 12);
}
