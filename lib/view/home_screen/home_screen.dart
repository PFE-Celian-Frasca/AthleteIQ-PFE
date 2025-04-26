import 'package:athlete_iq/app/provider/nav_bar_provider.dart';
import 'package:athlete_iq/generated/assets.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/providers/location/location_provider.dart';
import 'package:athlete_iq/resources/components/go_btn.dart';
import 'package:athlete_iq/utils/get_user_info_provider.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/utils/routing/custom_popup_route.dart';
import 'package:athlete_iq/view/home_screen/provider/cluster_provider.dart';
import 'package:athlete_iq/view/home_screen/provider/home_controller.dart';
import 'package:athlete_iq/view/parcour-detail/parcour_overlay_widget.dart.dart';
import 'package:athlete_iq/view/register_parcours_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:athlete_iq/providers/google_map_provider.dart';
import 'package:athlete_iq/providers/parcour_recording/parcours_recording_provider.dart';
import 'package:athlete_iq/resources/components/Button/custom_floating_button.dart';

import '../../ui/home/cluster/components/cluster_item_dialog.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final homeController = ref.read(homeControllerProvider.notifier);
    final parcoursRecordingState = ref.watch(parcoursRecordingNotifierProvider);
    final parcoursRecordingNotifier =
        ref.read(parcoursRecordingNotifierProvider.notifier);
    final chrono = ref.watch(timerProvider);
    final locationState = ref.watch(locationNotifierProvider);
    final locationNotifier = ref.read(locationNotifierProvider.notifier);
    final themeMode = Theme.of(context).brightness;
    GoogleMapController? mapController =
        ref.read(googleMapControllerProvider('homeMap').notifier).state;
    final clusterState = ref.watch(clusterNotifierProvider);
    final clusterNotifier = ref.read(clusterNotifierProvider.notifier);
    double? smoothedBearing;
    const double smoothingFactor = 0.1;
    final showDialogTrigger = useState(false);

    // Initialize the controller
    useEffect(() {
      Future.microtask(() => homeController.init());
      return null;
    }, []);

    useEffect(() {
      showDialogTrigger.value =
          homeState.showClusterDialog && homeState.clusterItems != null;
      return null;
    }, [homeState.showClusterDialog, homeState.clusterItems]);

    useEffect(() {
      if (showDialogTrigger.value) {
        Future.microtask(() => showDialog(
              context: context,
              builder: (BuildContext context) {
                return ClusterItemsDialog(
                  clusterItems: homeState.clusterItems!,
                  onSelectParcour: (ParcoursWithGPSData parcour) {
                    homeController.selectParcour(parcour);
                    homeController.hideClusterDialog();
                  },
                );
              },
            ).then((_) => homeController.hideClusterDialog()));

        showDialogTrigger.value = false;
      }
      return null;
    }, [showDialogTrigger.value]);

    Future<void> onMapCreated(GoogleMapController controller) async {
      ref.read(googleMapControllerProvider('homeMap').notifier).state =
          controller;
      if (themeMode == Brightness.dark) {
        String darkMapStyle =
            await rootBundle.loadString(Assets.jsonDarkModeStyle);
        controller.setMapStyle(darkMapStyle);
      }

      // Rafraîchir et centrer la caméra sur la position de l'utilisateur
      await ref
          .read(locationNotifierProvider.notifier)
          .refreshLocation()
          .then((_) {
        final locationState = ref.read(locationNotifierProvider);
        if (locationState.locationData != null) {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(locationState.locationData!.latitude!,
                    locationState.locationData!.longitude!),
                zoom: 14.4746,
              ),
            ),
          );
        } else {
          // Gérer le cas où la localisation n'est pas disponible
          ref.read(internalNotificationProvider).showToast(
              "Erreur: Les données de localisation ne sont pas disponibles");
        }
      }).catchError((error) {
        // Gérer les erreurs de récupération de la localisation
        ref.read(internalNotificationProvider).showToast(
            "Erreur lors de la récupération de la localisation: $error");
      });

      clusterNotifier.onMapCreated(controller);
      homeController.loadInitialParcours();
    }

    useEffect(() {
      if (parcoursRecordingState.isRecording &&
          mapController != null &&
          locationState.locationData != null) {
        double currentBearing = locationState.locationData!.heading!;
        if (smoothedBearing == null) {
          smoothedBearing = currentBearing;
        } else {
          double delta = currentBearing - smoothedBearing!;
          if (delta.abs() > 180) {
            delta = delta > 0 ? delta - 360 : delta + 360;
          }
          smoothedBearing = smoothedBearing! + smoothingFactor * delta;
          smoothedBearing = (smoothedBearing! + 360) % 360;
          if (smoothedBearing! > 180) {
            smoothedBearing = smoothedBearing! - 360;
          }
        }
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(locationState.locationData!.latitude!,
                    locationState.locationData!.longitude!),
                zoom: 18.0,
                tilt: 45,
                bearing: smoothedBearing!)));
      }
      return null;
    }, [parcoursRecordingState.isRecording, mapController, locationState]);

    Future<void> handleTap() async {
      if (!parcoursRecordingState.isRecording) {
        await parcoursRecordingNotifier.startRecording();
        ref.read(showNavBarProvider.notifier).state = false;
        ref.read(internalNotificationProvider);
      } else {
        await parcoursRecordingNotifier.stopRecording();
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(locationState.locationData!.latitude!,
                    locationState.locationData!.longitude!),
                zoom: 14.4746),
          ),
        );
        if (context.mounted) {
          Navigator.of(context).push(
            CustomPopupRoute(
              builder: (BuildContext context) {
                return const RegisterScreen();
              },
            ),
          ).then((_) {
            ref.read(showNavBarProvider.notifier).state = true;
            ref
                .read(parcoursRecordingNotifierProvider.notifier)
                .clearRecordedLocations();
          });
        }
      }
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: homeState.mapType,
            trafficEnabled: homeState.trafficEnabled,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            onMapCreated: onMapCreated,
            markers: clusterState.markers,
            polylines: clusterState.polylines,
            initialCameraPosition: CameraPosition(
              target: locationState.locationData != null
                  ? LatLng(locationState.locationData!.latitude!,
                      locationState.locationData!.longitude!)
                  : const LatLng(37.77483, -122.41942),
              zoom: 14.4746,
            ),
            zoomControlsEnabled: false,
            onCameraMove: (CameraPosition position) {
              clusterNotifier.clusterManager?.onCameraMove(position);
              homeController.updateCameraPosition(position);
            },
            onCameraIdle: () {
              clusterNotifier.clusterManager?.updateMap();
              homeController.checkOverlayVisibility();
            },
          ),
          if (homeState.parcourOverlayVisible &&
              homeState.selectedParcour != null)
            FutureBuilder<UserModel>(
              future: ref.watch(
                  getUserInfoProvider(homeState.selectedParcour!.parcours.owner)
                      .future),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return ParcourOverlayWidget(
                    title: homeState.selectedParcour!.parcours.title,
                    ownerName: snapshot.data!.pseudo,
                    onViewDetails: () {
                      homeController.closeParcourOverlay();
                      GoRouter.of(context).push(
                          '/home/parcours/details/${homeState.selectedParcour!.parcours.id}');
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: parcoursRecordingState.isRecording ? 1 : 0,
              child: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  height: 50.h,
                  width: 130.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    '${chrono.hours.toString().padLeft(2, '0')} : ${chrono.minutes.toString().padLeft(2, '0')} : ${chrono.seconds.toString().padLeft(2, '0')} ',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10.w,
            child: SafeArea(
              child: Column(
                children: [
                  CustomFloatingButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    heroTag: "menuBtn",
                    onPressed: () {
                      homeController.toggleMenu();
                    },
                    icon: homeState.isMenuOpen ? Icons.close : Icons.menu,
                    iconColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: homeState.isMenuOpen ? 200.h : 0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          buildToggleParcourTypeButton(
                              context, homeState, homeController, ref),
                          SizedBox(height: 10.h),
                          CustomFloatingButton(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            heroTag: "toggleTrafficBtn",
                            onPressed: () {
                              homeController.toggleTraffic();
                              ref.read(internalNotificationProvider).showToast(
                                  homeState.trafficEnabled
                                      ? 'Trafic désactivé'
                                      : 'Trafic activé');
                            },
                            icon: Icons.traffic,
                            iconColor: homeState.trafficEnabled
                                ? Colors.green
                                : Theme.of(context).colorScheme.onPrimary,
                          ),
                          SizedBox(height: 10.h),
                          CustomFloatingButton(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            heroTag: "toggleViewBtn",
                            onPressed: () {
                              homeController.toggleMapType();
                              ref.read(internalNotificationProvider).showToast(
                                  homeState.mapType == MapType.normal
                                      ? 'Passage à la vue satellite'
                                      : 'Passage à la vue normale');
                            },
                            icon: homeState.mapType == MapType.normal
                                ? Icons.terrain
                                : Icons.map,
                            iconColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 90.h,
            right: 10.w,
            child: !parcoursRecordingState.isRecording
                ? CustomFloatingButton(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    heroTag: "locateBtn",
                    onPressed: () async {
                      if (locationState.isLoading) {
                        return;
                      } else {
                        await locationNotifier.refreshLocation();
                        ref
                            .read(internalNotificationProvider)
                            .showToast('Position actualisée');
                        ref
                            .read(
                                googleMapControllerProvider('homeMap').notifier)
                            .state!
                            .animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(
                                      locationState.locationData!.latitude!,
                                      locationState.locationData!.longitude!),
                                  zoom: 14.4746,
                                ),
                              ),
                            );
                      }
                    },
                    icon: Icons.my_location,
                    iconColor: Theme.of(context).colorScheme.onBackground,
                    loadingWidget: !parcoursRecordingState.isRecording &&
                            locationState.isLoading
                        ? CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary)
                        : null,
                  )
                : const SizedBox(),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            alignment:
                Alignment(0, !parcoursRecordingState.isRecording ? 0.71 : 0.9),
            child: GoBtn(onTap: handleTap),
          ),
        ],
      ),
    );
  }

  Widget buildToggleParcourTypeButton(BuildContext context, HomeState homeState,
      HomeController homeController, WidgetRef ref) {
    final List<Map<String, dynamic>> parcourVisibilitys = [
      {'type': 'public', 'icon': Icons.public, 'label': 'Public'},
      {'type': 'private', 'icon': Icons.lock, 'label': 'Privé'},
      {'type': 'shared', 'icon': Icons.group, 'label': 'Partagé'},
      {'type': 'favorites', 'icon': Icons.favorite, 'label': 'Favoris'},
    ];

    int currentIndex = homeState.selectedFilter == null
        ? 0
        : parcourVisibilitys
            .indexWhere((p) => p['type'] == homeState.selectedFilter);
    currentIndex = currentIndex == -1 ? 0 : currentIndex;

    void showSelectionMenu() async {
      final selectedType = await showMenu<String>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        color: Theme.of(context).colorScheme.onPrimary,
        position: const RelativeRect.fromLTRB(0, 0, 0, 0),
        items: parcourVisibilitys
            .map((type) => PopupMenuItem<String>(
                  value: type['type'],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(type['icon'],
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(type['label'],
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSurface)),
                      ],
                    ),
                  ),
                ))
            .toList(),
        initialValue: parcourVisibilitys[currentIndex]['type'],
      );

      if (selectedType != null && selectedType != homeState.selectedFilter) {
        homeController.setFilter(selectedType);
        ref.read(internalNotificationProvider).showToast(
            'Filtre défini sur ${parcourVisibilitys.firstWhere((p) => p['type'] == selectedType)['label']}');
      }
    }

    return GestureDetector(
      onLongPress: showSelectionMenu,
      child: CustomFloatingButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        heroTag: "toggleParcourTypeBtn",
        onPressed: () {
          int nextIndex = (currentIndex + 1) % parcourVisibilitys.length;
          homeController.setFilter(parcourVisibilitys[nextIndex]['type']);
          ref.read(internalNotificationProvider).showToast(
              'Filtre défini sur ${parcourVisibilitys[nextIndex]['label']}');
        },
        icon: parcourVisibilitys[currentIndex]['icon'],
        iconColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
