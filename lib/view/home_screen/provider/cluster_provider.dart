import 'dart:async';
import 'dart:ui';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/generated/assets.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart' as cluster;
import 'package:athlete_iq/models/cluster/parcours_cluster_item.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/view/home_screen/provider/cluster_state.dart';
import 'dart:io' show Platform;
import 'package:athlete_iq/view/home_screen/provider/home_controller.dart';

final clusterNotifierProvider = StateNotifierProvider<ClusterNotifier, ClusterState>(
  (ref) => ClusterNotifier(ref),
);

class ClusterNotifier extends StateNotifier<ClusterState> {
  final Ref ref;
  cluster.ClusterManager<ParcoursWithGPSData>? clusterManager;
  BitmapDescriptor? _customMarkerIcon;
  StreamSubscription<CameraPosition>? _cameraPositionSubscription;
  GoogleMapController? _mapController;

  ClusterNotifier(this.ref) : super(const ClusterState()) {
    _initClusterManager();
  }

  Future<void> _initClusterManager() async {
    await loadCustomMarkerIcon();
    clusterManager = cluster.ClusterManager<ParcoursWithGPSData>(
      [],
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    clusterManager?.setMapId(controller.mapId);
    clusterManager?.updateMap(); // Mise à jour initiale pour configurer les clusters
  }

  Future<void> loadCustomMarkerIcon() async {
    try {
      _customMarkerIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(
          size: Size(48, 48),
        ),
        Platform.isIOS ? Assets.marker2Ios : Assets.marker2,
      );
    } catch (e) {
      _customMarkerIcon = BitmapDescriptor.defaultMarker;
    }
  }

  Future<Marker> _markerBuilder(cluster.Cluster<ParcoursWithGPSData> cluster) async {
    if (!cluster.isMultiple) {
      final ParcoursWithGPSData item = cluster.items.first;
      return Marker(
        markerId: MarkerId(item.parcours.id!),
        position: item.location,
        icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarker,
        onTap: () => ref.read(homeControllerProvider.notifier).selectParcour(item),
      );
    } else {
      final BitmapDescriptor clusterIcon = await _getClusterIcon(cluster.count);
      return Marker(
        markerId: MarkerId("cluster_${cluster.getId()}"),
        position: cluster.location,
        icon: clusterIcon,
        onTap: () {
          ref.read(homeControllerProvider.notifier).showClusterDialog(cluster.items.toSet());
        },
      );
    }
  }

  Future<BitmapDescriptor> _getClusterIcon(int clusterSize) async {
    const int size = 48;
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: '$clusterSize',
        style: const TextStyle(fontSize: size / 3, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);
    textPainter.layout();
    textPainter.paint(
        canvas, Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2));
    final image = await pictureRecorder.endRecording().toImage(size, size);
    final data = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  void _updateMarkers(Set<Marker> markers) {
    state = state.copyWith(markers: markers);
  }

  void _updatePolylines(Set<Polyline> polylines) {
    state = state.copyWith(polylines: polylines);
  }

  void createPolylineFromParcours(List<ParcoursWithGPSData> parcoursWithGPSData) {
    final Set<Polyline> polylines = parcoursWithGPSData.map((data) {
      final List<LatLng> allPoints = data.gpsData.map((gpsData) {
        return LatLng(gpsData.latitude, gpsData.longitude);
      }).toList();

      return Polyline(
          polylineId: PolylineId(data.parcours.id!),
          points: allPoints,
          width: 5,
          color: data.parcours.type == ParcourVisibility.public
              ? const Color(0xC005FF0C)
              : data.parcours.type == ParcourVisibility.shared
                  ? const Color(0xFFFFF200)
                  : const Color(0xFFFF2100));
    }).toSet();
    _updatePolylines(polylines);
  }

  void updateClusters(List<ParcoursWithGPSData> parcoursWithGPSData) async {
    final List<ParcoursClusterItem> clusterItems = [];
    for (final data in parcoursWithGPSData) {
      final UserModel user = await ref.read(userServiceProvider).getUserData(data.parcours.owner);
      final List<LatLng> allPoints =
          data.gpsData.map((gpsData) => LatLng(gpsData.latitude, gpsData.longitude)).toList();

      clusterItems.add(ParcoursClusterItem(
        id: data.parcours.id!,
        position: LatLng(data.gpsData.first.latitude, data.gpsData.first.longitude),
        icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarker,
        title: data.parcours.title,
        snippet: "Par : ${user.pseudo}",
        allPoints: allPoints,
      ));
    }
    createPolylineFromParcours(parcoursWithGPSData);
    clusterManager?.setItems(parcoursWithGPSData);
    clusterManager?.updateMap();
  }

  @override
  void dispose() {
    _cameraPositionSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}
