import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:athlete_iq/resources/components/ChoiceChip/custom_choice_chip.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/view/community/chat-page/components/generic_list_component.dart';
import 'package:athlete_iq/view/register_parcours_screen/provider/register_parcour_state.dart';
import 'package:flutter/material.dart';
import 'package:athlete_iq/view/register_parcours_screen/provider/register_parcour_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:athlete_iq/resources/components/Button/custom_floating_button.dart';
import 'package:athlete_iq/resources/components/InputField/custom_input_field.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chrono = ref.watch(timerProvider);
    final parcourState = ref.watch(registerParcourNotifierProvider);

    if (parcourState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Enregistrement",
        hasBackButton: true,
        backIcon: Icons.arrow_back,
        onBackButtonPressed: () => Navigator.of(context).pop(),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      _buildMap(context, parcourState.recordedLocations),
                      SizedBox(height: 20.h),
                      _buildStats(context, chrono, parcourState),
                      SizedBox(height: 20.h),
                      CustomChoiceChipSelector<ParcourVisibility>(
                        title: 'Type de parcours',
                        options: const {
                          ParcourVisibility.public: 'Public',
                          ParcourVisibility.private: 'Privé',
                          ParcourVisibility.shared: 'Partagé',
                        },
                        selectedValue: parcourState.parcourType,
                        onSelected: (ParcourVisibility value) {
                          ref.read(registerParcourNotifierProvider.notifier).setParcourType(value);
                        },
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                      SizedBox(height: 10.h),
                      if (parcourState.parcourType == ParcourVisibility.shared)
                        _buildFriendsSelector(context, parcourState, ref),
                      SizedBox(height: 20.h),
                      _buildTitleInput(context, ref),
                      _buildDescriptionInput(context, ref),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            right: 20.w,
            child: _buildSubmitButton(context, parcourState, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsSelector(
      BuildContext context, RegisterParcourState parcourState, WidgetRef ref) {
    return Column(
      children: [
        Text(
          "Partager avec des amis",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: parcourState.friends.isNotEmpty
              ? GenericListComponent<UserModel>(
                  onItemSelected: (UserModel friend) {
                    if (parcourState.friendsToShare.contains(friend.id)) {
                      ref
                          .read(registerParcourNotifierProvider.notifier)
                          .removeFriendToShare(friend.id);
                    } else {
                      ref
                          .read(registerParcourNotifierProvider.notifier)
                          .addFriendToShare(friend.id);
                    }
                  },
                  selectedIds: parcourState.friendsToShare,
                  excludeId: parcourState.owner?.id ?? '',
                  items: parcourState.friends,
                  idExtractor: (friend) => friend.id,
                  buildItem: (context, friend) => Text(friend.pseudo),
                  icon: const Icon(Icons.person),
                )
              : const Center(child: Text("Aucun ami à afficher")),
        ),
      ],
    );
  }

  Widget _buildMap(BuildContext context, List<LocationDataModel> locations) {
    if (locations.isEmpty) {
      return const Center(child: Text("Aucun parcours enregistré à afficher"));
    }

    final LatLngBounds bounds = _calculateBounds(locations);

    final Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        visible: true,
        points: locations.map((location) => LatLng(location.latitude, location.longitude)).toList(),
        color: Theme.of(context).colorScheme.primary,
        width: 4,
      ),
    };

    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('start'),
        position: LatLng(locations.first.latitude, locations.first.longitude),
        infoWindow: const InfoWindow(title: 'Départ'),
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: LatLng(locations.last.latitude, locations.last.longitude),
        infoWindow: const InfoWindow(title: 'Arrivée'),
      ),
    };

    final LatLng center = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
    );

    return SizedBox(
      height: 200.h,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 10,
          ),
          polylines: polylines,
          markers: markers,
        ),
      ),
    );
  }

  LatLngBounds _calculateBounds(List<LocationDataModel> locations) {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (final location in locations) {
      final double lat = location.latitude;
      final double lng = location.longitude;
      minLat = lat < minLat ? lat : minLat;
      maxLat = lat > maxLat ? lat : maxLat;
      minLng = lng < minLng ? lng : minLng;
      maxLng = lng > maxLng ? lng : maxLng;
    }

    final LatLng southwest = LatLng(minLat, minLng);
    final LatLng northeast = LatLng(maxLat, maxLng);

    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  Widget _buildStats(BuildContext context, CustomTimer chrono, RegisterParcourState parcourState) {
    return Column(
      children: [
        _buildStatRow(
          context,
          "Distance totale",
          "${parcourState.totalDistance?.toStringAsFixed(2) ?? '0.00'} km",
        ),
        _buildStatRow(
          context,
          "Altitude maximale",
          "${parcourState.maxAltitude?.toStringAsFixed(2) ?? '0.00'} m",
        ),
        _buildStatRow(
          context,
          "Altitude minimale",
          "${parcourState.minAltitude?.toStringAsFixed(2) ?? '0.00'} m",
        ),
        _buildStatRow(
          context,
          "Gain d'élévation",
          "${parcourState.elevationGain?.toStringAsFixed(2) ?? '0.00'} m",
        ),
        _buildStatRow(
          context,
          "Perte d'élévation",
          "${parcourState.elevationLoss?.toStringAsFixed(2) ?? '0.00'} m",
        ),
        _buildStatRow(
          context,
          "Vitesse minimale",
          "${parcourState.minSpeed?.toStringAsFixed(2) ?? '0.00'} km/h",
        ),
        _buildStatRow(
          context,
          "Vitesse maximale",
          "${parcourState.maxSpeed?.toStringAsFixed(2) ?? '0.00'} km/h",
        ),
        _buildStatRow(
          context,
          "Vitesse moyenne",
          "${parcourState.averageSpeed?.toStringAsFixed(2) ?? '0.00'} km/h",
        ),
        _buildStatRow(
          context,
          "Chrono",
          "${chrono.hours}:${chrono.minutes}:${chrono.seconds}",
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleInput(BuildContext context, WidgetRef ref) {
    return CustomInputField(
      label: 'Titre',
      icon: UniconsLine.map,
      keyboardType: TextInputType.text,
      onChanged: (value) => ref.read(registerParcourNotifierProvider.notifier).setTitle(value),
      validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un titre' : null,
      context: context,
    );
  }

  Widget _buildDescriptionInput(BuildContext context, WidgetRef ref) {
    return CustomInputField(
      label: 'Description',
      icon: UniconsLine.comment,
      onChanged: (value) =>
          ref.read(registerParcourNotifierProvider.notifier).setDescription(value),
      validator: (value) => null, // No validation needed for description
      context: context,
    );
  }

  Widget _buildSubmitButton(BuildContext context, RegisterParcourState state, WidgetRef ref) {
    return CustomFloatingButton(
      onPressed: () {
        if (state.parcourType == ParcourVisibility.shared && state.friendsToShare.isEmpty) {
          ref
              .watch(internalNotificationProvider)
              .showErrorToast("Veuillez sélectionner des amis avec qui partager votre parcours.");
          return;
        }
        ref.read(registerParcourNotifierProvider.notifier).submitParcours(context);
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: state.isLoading ? null : Icons.check,
      iconColor: state.isLoading ? Colors.transparent : Theme.of(context).colorScheme.onPrimary,
      loadingWidget: state.isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : null,
    );
  }
}
