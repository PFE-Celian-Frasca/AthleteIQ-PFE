import 'package:athlete_iq/app/provider/nav_bar_provider.dart';
import 'package:athlete_iq/generated/assets.dart';
import 'package:athlete_iq/providers/location/location_provider.dart';
import 'package:athlete_iq/resources/components/GoBtn.dart';
import 'package:athlete_iq/utils/get_user_info_provider.dart';
import 'package:athlete_iq/utils/routes/customPopupRoute.dart';
import 'package:athlete_iq/view/home_screen/provider/cluter_provider.dart';
import 'package:athlete_iq/view/home_screen/provider/home_provider.dart';
import 'package:athlete_iq/view/home_screen/provider/home_state.dart';
import 'package:athlete_iq/view/parcour-detail/parcour_overlay_widget.dart.dart';
import 'package:athlete_iq/view/register_parcours_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:athlete_iq/providers/google_map_provider.dart';
import 'package:athlete_iq/providers/parcour_recording/parcours_recording_provider.dart';
import 'package:athlete_iq/resources/components/Button/CustomFloatingButton.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final parcoursRecordingState = ref.watch(parcoursRecordingNotifierProvider);
    final parcoursRecordingNotifier =
        ref.read(parcoursRecordingNotifierProvider.notifier);
    final chrono = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final locationState = ref.watch(locationNotifierProvider);
    final locationNotifier = ref.watch(locationNotifierProvider.notifier);
    final themeMode = Theme.of(context).brightness;
    GoogleMapController? mapController =
        ref.read(googleMapControllerProvider('homeMap').notifier).state;
    final clusterState = ref.watch(clusterNotifierProvider);
    final clusterNotifier = ref.read(clusterNotifierProvider.notifier);
    double? smoothedBearing;
    const double smoothingFactor = 0.1;

    //  useEffect(() {
    //    Future<void> initializePosition() async {
    //     homeNotifier.initializeMapPositions();
    //   }

    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     initializePosition();
    //   });
    //   return null;
    // }, [homeNotifier]); // Depend on notifier to handle re-initializations

    Future<void> onMapCreated(GoogleMapController controller) async {
      ref.read(googleMapControllerProvider('homeMap').notifier).state =
          controller;
      if (themeMode == Brightness.dark) {
        String darkMapStyle =
            await rootBundle.loadString(Assets.jsonDarkModeStyle);
        controller.setMapStyle(darkMapStyle);
      }
      await locationNotifier.refreshLocation().then((value) {
        if (locationState.locationData != null) {
          ref
              .read(googleMapControllerProvider('homeMap').notifier)
              .state!
              .animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(locationState.locationData!.latitude!,
                        locationState.locationData!.longitude!),
                    zoom: 14.4746,
                  ),
                ),
              );
        }
      });
      clusterNotifier.onMapCreated(controller);
      homeNotifier.loadInitialParcours();
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
            // We have passed the -180/180 boundary, adjust the delta
            delta = delta > 0 ? delta - 360 : delta + 360;
          }
          smoothedBearing = smoothedBearing! + smoothingFactor * delta;
          // Normalize the bearing to the -180/180 range
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
    }, [
      parcoursRecordingState.isRecording,
      mapController,
      locationState
    ]); // Dépendances de useEffect

    Future<void> handleTap() async {
      if (!parcoursRecordingState.isRecording) {
        await parcoursRecordingNotifier.startRecording();
        ref.read(showNavBarProvider.notifier).state = false;
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
                  : const LatLng(37.77483, -122.41942), // Fallback position
              zoom: 14.4746,
            ),
            zoomControlsEnabled: false,
            onCameraMove: (CameraPosition position) {
              clusterNotifier.clusterManager?.onCameraMove(
                  position); // Informe le clusterManager du mouvement de la caméra
            },
            onCameraIdle: () {
              clusterNotifier.clusterManager
                  ?.updateMap(); // Recalcule et met à jour les clusters lorsque l'utilisateur a fini de bouger la caméra
            },
          ),
          if (homeState.parcourOverlayVisible &&
              homeState.selectedParcour != null)
            FutureBuilder<UserModel>(
              future: ref.read(
                  getUserInfoProvider(homeState.selectedParcour!.parcours.owner)
                      as ProviderListenable<Future<UserModel>?>),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return ParcourOverlayWidget(
                    title: homeState.selectedParcour!.parcours.title,
                    ownerName: snapshot.data!.pseudo,
                    onViewDetails: () {
                      // Detail view logic
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
                            .onBackground
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
                    onPressed: homeNotifier.toggleMenu,
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
                              context, homeState, homeNotifier),
                          SizedBox(height: 10.h),
                          CustomFloatingButton(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            heroTag: "toggleTrafficBtn",
                            onPressed: homeNotifier.toggleTraffic,
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
                            onPressed: homeNotifier.toggleMapType,
                            icon: homeState.mapType == MapType.normal
                                ? Icons.map
                                : Icons.satellite,
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

  Widget buildToggleParcourTypeButton(
      BuildContext context, HomeState homeState, HomeNotifier homeNotifier) {
    final List<Map<String, dynamic>> parcoursTypes = [
      {'type': 'Public', 'icon': Icons.public},
      {'type': 'Private', 'icon': Icons.lock},
      {'type': 'Shared', 'icon': Icons.group},
      {'type': 'Favorites', 'icon': Icons.favorite},
    ];

    int currentIndex = homeState.selectedFilter == null
        ? 0
        : parcoursTypes
            .indexWhere((p) => p['type'] == homeState.selectedFilter);
    currentIndex = currentIndex == -1
        ? 0
        : currentIndex; // Default to 'Public' if current filter not found

    return CustomFloatingButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      heroTag: "toggleParcourTypeBtn",
      onPressed: () {
        int nextIndex = (currentIndex + 1) % parcoursTypes.length;
        homeNotifier.setFilter(parcoursTypes[nextIndex]['type']);
      },
      icon: parcoursTypes[currentIndex]['icon'],
      iconColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
