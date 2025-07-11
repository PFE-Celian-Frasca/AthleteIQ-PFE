import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/parcour/single_parcour/single_parcour_provider.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/resources/components/ConfirmationDialog/custom_confirmation_dialog.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/utils/map_utils.dart';
import 'package:athlete_iq/utils/parcour_utils.dart';
import 'package:athlete_iq/utils/routing/custom_popup_route.dart';
import 'package:athlete_iq/utils/string_capitalize.dart';
import 'package:athlete_iq/view/info/components/caracteristique_component.dart';
import 'package:athlete_iq/view/parcour-detail/provider/favorite_provider.dart';
import 'package:athlete_iq/view/parcour-detail/provider/user_weight_provider.dart';
import 'package:athlete_iq/view/parcour-detail/update_parcour_screen.dart';
import 'package:flutter/material.dart';
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
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      return const Center(child: Text("Utilisateur non connecté"));
    }

    final userId = currentUser.uid;
    final parcoursStream = ref.watch(singleParcoursWithGPSDataProvider(parcourId));
    final userStream = ref.watch(userStateChangesProvider(userId));

    return Scaffold(
      body: parcoursStream.when(
        data: (parcourData) => UserFutureBuilder(
          ownerId: parcourData.parcours.owner,
          builder: (context, owner) {
            return userStream.when(
              data: (user) => ParcourDetailsPage(
                parcour: parcourData.parcours,
                gpsData: parcourData.gpsData,
                user: user!,
                owner: owner,
                ref: ref,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (message, _) => Center(child: Text('User error: $message')),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message, _) => Center(child: Text('Parcour error: $message')),
      ),
    );
  }
}

class UserFutureBuilder extends ConsumerWidget {
  final String ownerId;
  final Widget Function(BuildContext, UserModel) builder;

  const UserFutureBuilder({
    required this.ownerId,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<UserModel>(
      future: ref.read(userRepositoryProvider).getUserData(ownerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Owner not found'));
        }
        return builder(context, snapshot.data!);
      },
    );
  }
}

class ParcourDetailsPage extends StatelessWidget {
  final ParcoursModel parcour;
  final List<LocationDataModel> gpsData;
  final UserModel user;
  final UserModel owner;
  final WidgetRef ref;

  const ParcourDetailsPage({
    required this.parcour,
    required this.gpsData,
    required this.user,
    required this.owner,
    required this.ref,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: parcour.title.capitalize(),
        hasBackButton: true,
        backIcon: Icons.arrow_back,
        onBackButtonPressed: () => Navigator.of(context).pop(),
        actions: [
          FavoriteButton(
            userId: user.id,
            parcourId: parcour.id!,
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 24.w,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => showOptionsDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildGoogleMap(context),
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
                  buildSectionTitle(context, "Description"),
                  Text(
                    parcour.description ?? "Aucune description disponible",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 20.h),
                  buildSectionTitle(context, "Caractéristiques"),
                  buildCaracteristiqueList(),
                  const WeightSlider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGoogleMap(context) {
    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: LatLng(gpsData.first.latitude, gpsData.first.longitude),
      infoWindow: const InfoWindow(title: 'Début'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: LatLng(gpsData.last.latitude, gpsData.last.longitude),
      infoWindow: const InfoWindow(title: 'Fin'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    return SizedBox(
      height: 250.h,
      child: GoogleMap(
        compassEnabled: false,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        myLocationButtonEnabled: false,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(gpsData.first.latitude, gpsData.first.longitude),
          zoom: 14,
        ),
        markers: {startMarker, endMarker},
        polylines: {
          Polyline(
            polylineId: PolylineId(parcour.id!),
            points: gpsData.map((e) => LatLng(e.latitude, e.longitude)).toList(),
            color: Theme.of(context).colorScheme.primary,
            width: 5,
          ),
        },
        onMapCreated: (GoogleMapController controller) async {
          await Future.delayed(const Duration(milliseconds: 100));
          controller.animateCamera(
            CameraUpdate.newLatLngBounds(
              MapUtils.boundsFromLatLngList(
                gpsData.map((e) => LatLng(e.latitude, e.longitude)).toList(),
              ),
              100,
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Widget buildCaracteristiqueList() {
    return Column(
      children: [
        CaracteristiqueWidget(
          iconData: UniconsLine.clock,
          label: "Durée",
          value:
              "${parcour.timer.hours.toString().padLeft(2, '0')}:${parcour.timer.minutes.toString().padLeft(2, '0')}:${parcour.timer.seconds.toString().padLeft(2, '0')}",
          unit: "h:m:s",
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
            timer: parcour.timer,
          ).toStringAsFixed(2),
          unit: "Km/h",
        ),
        CaracteristiqueWidget(
          iconData: UniconsLine.arrow_up,
          label: "Vitesse max",
          value: calculateMaxSpeed(gpsData).toStringAsFixed(2),
          unit: "Km/h",
        ),
        CaracteristiqueWidget(
          iconData: UniconsLine.plus,
          label: "Dénivelé +",
          value: calculateTotalElevationGain(gpsData).toStringAsFixed(2),
          unit: "m",
        ),
        CaracteristiqueWidget(
          iconData: UniconsLine.minus,
          label: "Dénivelé -",
          value: calculateTotalElevationLoss(gpsData).toStringAsFixed(2),
          unit: "m",
        ),
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
        CaloriesBurnedWidget(parcour: parcour), // Utilisation du nouveau widget
      ],
    );
  }

  void showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Options',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        if (user.id == parcour.owner)
                          ListTile(
                            leading: Icon(
                              UniconsLine.edit,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: const Text("Modifier"),
                            onTap: () {
                              Navigator.of(context).push(
                                CustomPopupRoute(
                                  builder: (BuildContext context) {
                                    return UpdateParcourScreen(parcourId: parcour.id!);
                                  },
                                ),
                              );
                            },
                          ),
                        if (user.id == parcour.owner)
                          ListTile(
                            leading: Icon(
                              UniconsLine.trash_alt,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            title: const Text("Supprimer"),
                            onTap: () {
                              showDeleteParcourConfirmationDialog(context, () async {
                                GoRouter.of(context).pop();
                                deleteParcour();
                              });
                            },
                          ),
                        ListTile(
                          leading: Icon(
                            UniconsLine.share_alt,
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
  }

  void shareParcour(String parcourId) {
    final String url = 'https://athleteiq.fr/parcours/details/$parcourId';
    Share.share('Regardez ce parcours incroyable sur AthleteIQ: $url');
  }

  void deleteParcour() {
    ref.read(singleParcoursProvider.notifier).deleteParcours(parcour.id!);
    ref.read(internalNotificationProvider).showToast("Le parcours a été supprimé avec succès");
  }

  void showDeleteParcourConfirmationDialog(
    BuildContext context,
    Function onDelete,
  ) {
    showDialog(
      context: context,
      builder: (context) => CustomConfirmationDialog(
        title: "Supprimer le parcours",
        content: "Êtes-vous sûr de vouloir supprimer ce parcours ? Cette action est irréversible.",
        confirmText: "Supprimer",
        cancelText: "Annuler",
        backgroundColor: Theme.of(context).colorScheme.error,
        onConfirm: () async {
          try {
            await onDelete();
            if (context.mounted) {
              GoRouter.of(context).go('/info');
            }
          } catch (e) {
            ref
                .read(internalNotificationProvider)
                .showErrorToast("Erreur lors de la suppression du parcours");
          }
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class WeightSlider extends ConsumerWidget {
  const WeightSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ces valeurs sont basées sur un poids de ${ref.watch(userWeightProvider)} Kg et sont approximatives. Les valeurs réelles peuvent varier en fonction de plusieurs facteurs.",
        ),
        Slider(
          value: ref.watch(userWeightProvider),
          min: 30,
          max: 150,
          divisions: 120,
          label: "${ref.watch(userWeightProvider)} Kg",
          onChanged: (double value) {
            ref.read(userWeightProvider.notifier).setUserWeight(value);
          },
        ),
      ],
    );
  }
}

class CaloriesBurnedWidget extends ConsumerWidget {
  final ParcoursModel parcour;

  const CaloriesBurnedWidget({required this.parcour, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caloriesBurned = ref.watch(caloriesBurnedProvider(parcour));
    return CaracteristiqueWidget(
      iconData: UniconsLine.fire,
      label: "Calories brûlées",
      value: caloriesBurned.toStringAsFixed(2),
      unit: "Kcal",
    );
  }
}

class FavoriteButton extends ConsumerWidget {
  final String userId;
  final String parcourId;

  const FavoriteButton({
    required this.userId,
    required this.parcourId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(favoriteNotifierProvider);
    final isFavorite = favoriteState[parcourId] ?? false;

    return IconButton(
      icon: Icon(
        isFavorite ? MdiIcons.heart : MdiIcons.heartOutline,
        color: isFavorite ? Theme.of(context).colorScheme.primary : null,
      ),
      onPressed: () =>
          ref.read(favoriteNotifierProvider.notifier).toggleFavorite(userId, parcourId, isFavorite),
    );
  }
}
