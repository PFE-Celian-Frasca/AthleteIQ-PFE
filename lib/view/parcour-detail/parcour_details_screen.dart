import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/providers/google_map_provider.dart';
import 'package:athlete_iq/providers/parcour/parcours_provider.dart';
import 'package:athlete_iq/providers/parcour/single_parcour/single_parcour_provider.dart';
import 'package:athlete_iq/providers/user/user_provider.dart';
import 'package:athlete_iq/resources/components/ConfirmationDialog/CustomConfirmationDialog.dart';
import 'package:athlete_iq/resources/components/CustomAppBar.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_provider.dart';
import 'package:athlete_iq/utils/map_utils.dart';
import 'package:athlete_iq/utils/parcour_utils.dart';
import 'package:athlete_iq/utils/routes/customPopupRoute.dart';
import 'package:athlete_iq/utils/stringCapitalize.dart';
import 'package:athlete_iq/view/info/components/caract%C3%A9ristiqueComponent.dart';
import 'package:athlete_iq/view/info/provider/all_parcours_list/combined_parcours_provider.dart';
import 'package:athlete_iq/view/parcour-detail/provider/user_weight_provider.dart';
import 'package:athlete_iq/view/parcour-detail/update_parcour_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';

class ParcourDetails extends HookConsumerWidget {
  final String parcourId;

  const ParcourDetails({required this.parcourId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcoursState = ref.watch(singleParcoursProvider);
    final parcoursNotifier = ref.read(singleParcoursProvider.notifier);
    final user = ref.watch(globalProvider.select((state) =>
        state.userState.maybeWhen(orElse: () => null, loaded: (user) => user)));

    // Initiate loading outside of the build method to avoid modifications during build
    useEffect(() {
      Future.microtask(() => parcoursNotifier.loadParcoursById(parcourId));
      return null;
    }, [parcourId]);

    return parcoursState.when(
      initial: () => const Scaffold(body: Center(child: Text('Initial state'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (message) =>
          Scaffold(body: Center(child: Text('Error: $message'))),
      loaded: (parcourData, owner) => buildPage(context, parcourData.parcours,
          parcourData.gpsData, user!, owner, ref),
    );
  }

  Scaffold buildPage(
      BuildContext context,
      ParcoursModel parcour,
      List<LocationDataModel> gpsData,
      UserModel? user, // Acknowledging that user can be null
      UserModel owner,
      WidgetRef ref) {
    GoogleMapController? mapController =
        ref.watch(googleMapControllerProvider(parcour.id!).notifier).state;

    final bool isFavorite = user?.fav.contains(parcour.id) ?? false;
    final bool userStateIsLoading = ref.watch(globalProvider.select((state) =>
        state.userState.maybeWhen(orElse: () => false, loading: () => true)));
    final caloriesBurned = ref.watch(caloriesBurnedProvider(parcour));

    Future<void> toggleFavorite(bool isFavorite) async {
      if (!userStateIsLoading) {
        await ref
            .read(userProvider.notifier)
            .toggleFavoriteParcours(user!.id, parcour.id!, !isFavorite);
        await ref.read(combinedParcoursProvider.notifier).getFavorites();
      }
    }

    void deleteParcour() {
      ref.read(singleParcoursProvider.notifier).deleteParcours(parcour.id!);
    }

    void editParcour() {
      GoRouter.of(context).push('/edit',
          extra: ParcoursWithGPSData(parcours: parcour, gpsData: gpsData));
    }

    void shareParcour(String parcourId) {
      String url = 'https://athleteiq.fr/parcours/details/$parcourId';
      Share.share('Regardez ce parcours incroyable sur AthleteIQ: $url');
    }

    // Handling UI when user is null
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(parcour.title.capitalize()),
          leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        ),
        body: const Center(child: Text("User information not available")),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: parcour.title.capitalize(),
        hasBackButton: true,
        backIcon: Icons.arrow_back,
        onBackButtonPressed: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
              icon: Icon(isFavorite ? MdiIcons.heart : MdiIcons.heartOutline,
                  color: isFavorite
                      ? Theme.of(context).colorScheme.primary
                      : null),
              onPressed: () => toggleFavorite(isFavorite)),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 24.w,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Options',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Icon(Icons.close,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  if (user.id == owner.id)
                                    ListTile(
                                      leading: Icon(UniconsLine.edit,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      title: const Text("Modifier"),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          CustomPopupRoute(
                                            builder: (BuildContext context) {
                                              return UpdateParcourScreen();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  if (user.id == owner.id)
                                    ListTile(
                                      leading: Icon(
                                        UniconsLine.trash_alt,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                      title: const Text("Supprimer"),
                                      onTap: () {
                                        showDeleteParcourConfirmationDialog(
                                          context,
                                          () async {
                                            GoRouter.of(context).pop();
                                            deleteParcour();
                                          },
                                          ref,
                                        );
                                      },
                                    ),
                                  ListTile(
                                    leading: Icon(UniconsLine.share_alt,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    title: const Text("Partager"),
                                    onTap: () {
                                      shareParcour(parcour.id!);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250.h,
              child: GoogleMap(
                compassEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(gpsData.first.latitude, gpsData.first.longitude),
                  zoom: 14,
                ),
                polylines: {
                  Polyline(
                    polylineId: PolylineId(parcour.id!),
                    points: gpsData
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                    color: Theme.of(context).colorScheme.primary,
                    width: 5,
                  )
                },
                onMapCreated: (GoogleMapController controller) async {
                  mapController = controller;
                  await Future.delayed(const Duration(
                      milliseconds: 100)); // Allow time for the map to render
                  controller.animateCamera(CameraUpdate.newLatLngBounds(
                      MapUtils.boundsFromLatLngList(gpsData
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList()),
                      100));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Créé par: ${owner.pseudo.capitalize()}',
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    parcour.description ?? "Aucune description disponible",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Caractéristiques",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  CaracteristiqueWidget(
                    iconData: UniconsLine.clock,
                    label: "Durée",
                    value:
                        "${parcour.timer.hours.toString()}h ${parcour.timer.minutes.toString()}m ${parcour.timer.seconds.toString()}s",
                    unit: "",
                  ),
                  CaracteristiqueWidget(
                    iconData: UniconsLine.ruler_combined,
                    label: "Distance",
                    value: parcour.totalDistance.toStringAsFixed(2),
                    unit: "Km",
                  ),
                  CaracteristiqueWidget(
                      iconData: UniconsLine.dashboard,
                      label: "Vitesse moyenne",
                      value: calculateAverageSpeed(
                              totalDistance: parcour.totalDistance,
                              timer: parcour.timer)
                          .toStringAsFixed(2),
                      unit: "Km/h"),
                  CaracteristiqueWidget(
                    iconData: UniconsLine.arrow_up,
                    label: "Vitesse max",
                    value: calculateMaxSpeed(gpsData).toStringAsFixed(2),
                    unit: "Km/h",
                  ),
                  CaracteristiqueWidget(
                      iconData: UniconsLine.plus,
                      label: "Dénivelé +",
                      value: calculateTotalElevationGain(gpsData)
                          .toStringAsFixed(2),
                      unit: "m"),
                  CaracteristiqueWidget(
                      iconData: UniconsLine.minus,
                      label: "Dénivelé -",
                      value: calculateTotalElevationLoss(gpsData)
                          .toStringAsFixed(2),
                      unit: "m"),
                  CaracteristiqueWidget(
                    iconData: UniconsLine.mountains,
                    label: "Altitude max",
                    value: calculateMaxAltitude(gpsData)!.toStringAsFixed(2),
                    unit: "m",
                  ),
                  CaracteristiqueWidget(
                    iconData: UniconsLine.mountains,
                    label: "Altitude min",
                    value: calculateMinAltitude(gpsData)!.toStringAsFixed(2),
                    unit: "m",
                  ),
                  CaracteristiqueWidget(
                    iconData: UniconsLine.fire,
                    label: "Calories brûlées",
                    value: caloriesBurned.toStringAsFixed(2),
                    unit: "Kcal",
                  ),
                  Text(
                      "Ces valeurs sont basées sur un poids de ${caloriesBurned.round()} Kg et sont approximatives. Les valeurs réelles peuvent varier en fonction de plusieurs facteurs."),
                  Slider(
                    value: ref.read(userWeightProvider.notifier).state,
                    min: 30,
                    max: 150,
                    divisions: 120,
                    label: "${caloriesBurned.round()} Kg",
                    onChanged: (double value) {
                      ref.read(userWeightProvider.notifier).state = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteParcourConfirmationDialog(
      BuildContext context, Function onDelete, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => CustomConfirmationDialog(
        title: "Supprimer le parcours",
        content:
            "Êtes-vous sûr de vouloir supprimer ce parcours ? Cette action est irréversible.",
        confirmText: "Supprimer",
        cancelText: "Annuler",
        backgroundColor: Theme.of(context).colorScheme.error,
        onConfirm: () async {
          try {
            await onDelete(); // La fonction à exécuter pour supprimer
            GoRouter.of(context).go('/parcours');
          } catch (e) {
            ref
                .read(notificationNotifierProvider.notifier)
                .showErrorToast("Erreur lors de la suppression du parcours");
          }
        },
        onCancel: () =>
            Navigator.of(context).pop(), // Fermer le dialogue sans action
      ),
    );
  }
}
