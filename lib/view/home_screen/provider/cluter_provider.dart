import 'dart:async';
import 'dart:ui';
import 'package:athlete_iq/generated/assets.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart' as cluster;
import 'package:athlete_iq/models/cluster/parcours_cluster_item.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'cluster_state.dart';
import 'dart:io' show Platform;

final clusterNotifierProvider =
    StateNotifierProvider<ClusterNotifier, ClusterState>(
  (ref) => ClusterNotifier(ref),
);

class ClusterNotifier extends StateNotifier<ClusterState> {
  final Ref ref;
  cluster.ClusterManager<ParcoursClusterItem>? clusterManager;
  BitmapDescriptor? _customMarkerIcon;
  StreamSubscription<CameraPosition>? _cameraPositionSubscription;
  GoogleMapController? _mapController;

  ClusterNotifier(this.ref) : super(const ClusterState()) {
    _initClusterManager();
  }

  Future<void> _initClusterManager() async {
    await loadCustomMarkerIcon();
    clusterManager = cluster.ClusterManager<ParcoursClusterItem>(
      [],
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    clusterManager?.setMapId(controller.mapId);
    clusterManager
        ?.updateMap(); // Mise à jour initiale pour configurer les clusters
  }

  Future<void> loadCustomMarkerIcon() async {
    try {
      _customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(48, 48),
        ),
        Platform.isIOS ? Assets.marker2Ios : Assets.marker2,
      );
    } catch (e) {
      _customMarkerIcon = BitmapDescriptor.defaultMarker;
    }
  }

  Future<Marker> _markerBuilder(cluster.Cluster<ParcoursClusterItem> cluster) async {
    if (!cluster.isMultiple) {
      ParcoursClusterItem item = cluster.items.first;
      return Marker(
          markerId: MarkerId(item.id),
          position: item.position,
          icon: item.icon,
          infoWindow: InfoWindow(title: item.title, snippet: item.snippet),
          onTap: () => print("click"));
    } else {
      BitmapDescriptor clusterIcon = await _getClusterIcon(cluster.count);
      return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          icon: clusterIcon,
          onTap: () => print("click"));
    }
  }

  Future<BitmapDescriptor> _getClusterIcon(int clusterSize) async {
    // Custom logic to generate cluster icons based on the size
    final int size = (clusterSize < 10)
        ? 100
        : (clusterSize < 100)
            ? 120
            : 140;
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: '$clusterSize',
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            (size - textPainter.width) / 2, (size - textPainter.height) / 2));
    final image = await pictureRecorder.endRecording().toImage(size, size);
    final data = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void _updateMarkers(Set<Marker> markers) {
    state = state.copyWith(markers: markers);
  }

  void _updatePolylines(Set<Polyline> polylines) {
    state = state.copyWith(polylines: polylines);
  }

  void _onClusterTap(Set<ParcoursClusterItem> clusterItems) {
    print(
        "Cluster tapped with items: ${clusterItems.map((i) => i.id).join(', ')}");
  }

  void createPolylineFromParcours(
      List<ParcoursWithGPSData> parcoursWithGPSData) {
    Set<Polyline> polylines = parcoursWithGPSData.map((data) {
      // Convert each LocationDataModel to LatLng
      List<LatLng> allPoints = data.gpsData.map((gpsData) {
        return LatLng(gpsData.latitude, gpsData.longitude);
      }).toList();

      // Build polyline for the parcours
      return Polyline(
          polylineId: PolylineId(data.parcours.id!),
          points:
              allPoints, // Store polyline in ParcoursClusterItem for later use
          width: 5,
          color: data.parcours.type == ParcoursType.Public
              ? const Color(0xC005FF0C)
              : data.parcours.type == ParcoursType.Shared
                  ? const Color(0xFFFFF200)
                  : const Color(0xFFFF2100));
    }).toSet();
    // Update markers and polylines
    _updatePolylines(polylines);
  }

  void updateClusters(List<ParcoursWithGPSData> parcoursWithGPSData) {
    List<ParcoursClusterItem> clusterItems = parcoursWithGPSData.map((data) {
      // Convert each LocationDataModel to LatLng
      List<LatLng> allPoints = data.gpsData.map((gpsData) {
        return LatLng(gpsData.latitude, gpsData.longitude);
      }).toList();

      return ParcoursClusterItem(
        id: data.parcours.id!,
        position:
            LatLng(data.gpsData.first.latitude, data.gpsData.first.longitude),
        icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarker,
        title: data.parcours.title,
        snippet:
            "Par : ${ref.read(userServiceProvider).getUserData(data.parcours.owner).then((value) => value.pseudo)}",
        allPoints: allPoints, // Store polyline in ParcoursClusterItem
      );
    }).toList();
    createPolylineFromParcours(parcoursWithGPSData);
    // Get all polylines from cluster items

    clusterManager?.setItems(clusterItems);
    clusterManager?.updateMap();
  }

  @override
  void dispose() {
    _cameraPositionSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}
