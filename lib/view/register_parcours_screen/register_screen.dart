import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/providers/parcour/parcours_provider.dart';
import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:athlete_iq/utils/map_utils.dart';
import 'package:athlete_iq/view/register_parcours_screen/provider/register_parcour_state.dart';
import 'package:flutter/material.dart';
import 'package:athlete_iq/view/register_parcours_screen/provider/register_parcour_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:athlete_iq/resources/components/Button/CustomFloatingButton.dart';
import 'package:athlete_iq/resources/components/InputField/CustomInputField.dart';

import '../../utils/internal_notification/internal_notification_provider.dart';

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
      appBar: AppBar(
        title: const Text("Enregistrement de parcours"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
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
                  _buildParcourTypeSelector(context, ref, parcourState),
                  SizedBox(height: 20.h),
                  _buildTitleInput(context, ref),
                  _buildDescriptionInput(context, ref),
                  if (parcourState.parcourType == ParcoursType.Shared)
                    _buildFriendsShareList(ref, parcourState),
                  _buildSubmitButton(context, parcourState, ref),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context, List<LocationDataModel> locations) {
    final List<LatLng> latLngList = locations
        .map((location) => LatLng(location.latitude, location.longitude))
        .toList();
    LatLngBounds bounds = MapUtils.boundsFromLatLngList(latLngList);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 250.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            controller.moveCamera(CameraUpdate.newLatLngBounds(bounds, 50));
          },
          initialCameraPosition: CameraPosition(
            target:
                latLngList.isNotEmpty ? latLngList.first : const LatLng(0, 0),
            zoom: 12,
          ),
          polylines: {
            Polyline(
              polylineId: const PolylineId('NewParcour'),
              points: latLngList,
              color: Colors.blue,
              width: 5,
            )
          },
          mapType: MapType.normal,
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          myLocationButtonEnabled: false,
        ),
      ),
    );
  }

  Widget _buildStats(
      BuildContext context, CustomTimer chrono, RegisterParcourState state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatRow('Time',
              '${chrono.hours.toString().padLeft(2, '0')}:${chrono.minutes.toString().padLeft(2, '0')}:${chrono.seconds.toString().padLeft(2, '0')}'),
          _buildStatRow(
              'Distance', '${state.totalDistance?.toStringAsFixed(2)} KM'),
          _buildStatRow(
              'Max Altitude', '${state.maxAltitude?.toStringAsFixed(2)} m'),
          _buildStatRow(
              'Min Altitude', '${state.minAltitude?.toStringAsFixed(2)} m'),
          _buildStatRow(
              'Elevation Gain', '${state.elevationGain?.toStringAsFixed(2)} m'),
          _buildStatRow(
              'Elevation Loos', '${state.elevationLoss?.toStringAsFixed(2)} m'),
          _buildStatRow(
              'Min Speed', '${state.minSpeed?.toStringAsFixed(2)} km/h'),
          _buildStatRow(
              'Max Speed', '${state.maxSpeed?.toStringAsFixed(2)} km/h'),
          _buildStatRow('Average Speed',
              '${state.averageSpeed?.toStringAsFixed(2)} km/h'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }

  Widget _buildParcourTypeSelector(
      BuildContext context, WidgetRef ref, RegisterParcourState state) {
    return DropdownButton<ParcoursType>(
      value: state.parcourType,
      onChanged: (ParcoursType? newValue) {
        if (newValue != null) {
          ref
              .read(registerParcourNotifierProvider.notifier)
              .setParcourType(newValue);
        }
      },
      items: ParcoursType.values
          .map<DropdownMenuItem<ParcoursType>>((ParcoursType type) {
        return DropdownMenuItem<ParcoursType>(
          value: type,
          child: Text(type.toString().split('.').last),
        );
      }).toList(),
    );
  }

  Widget _buildTitleInput(BuildContext context, WidgetRef ref) {
    return CustomInputField(
      label: 'Titre',
      icon: UniconsLine.map,
      onChanged: (value) =>
          ref.read(registerParcourNotifierProvider.notifier).setTitle(value),
      validator: (value) =>
          value == null || value.isEmpty ? 'Veuillez entrer un titre' : null,
      context: context,
    );
  }

  Widget _buildDescriptionInput(BuildContext context, WidgetRef ref) {
    return CustomInputField(
      label: 'Description',
      icon: UniconsLine.comment,
      onChanged: (value) => ref
          .read(registerParcourNotifierProvider.notifier)
          .setDescription(value),
      maxLines: 3,
      validator: (value) => null, // No validation needed for description
      context: context,
    );
  }

  Widget _buildFriendsShareList(WidgetRef ref, RegisterParcourState state) {
    return Visibility(
      visible: state.parcourType == ParcoursType.Shared,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.friends.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(state.friends[index].pseudo),
            value: state.friendsToShare.contains(state.friends[index].id),
            onChanged: (bool? value) {
              if (value != null) {
                if (value) {
                  ref
                      .read(registerParcourNotifierProvider.notifier)
                      .addFriendToShare(state.friends[index].id);
                } else {
                  ref
                      .read(registerParcourNotifierProvider.notifier)
                      .removeFriendToShare(state.friends[index].id);
                }
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, RegisterParcourState state, WidgetRef ref) {
    // Observation de l'état du parcoursProvider pour gérer l'affichage du loader
    final isLoading = ref
        .watch(parcoursProvider)
        .maybeWhen(loading: () => true, orElse: () => false);

    return CustomFloatingButton(
      onPressed: () async {
        if (state.parcourType == ParcoursType.Shared &&
            state.friendsToShare.isEmpty) {
          ref
              .read(notificationNotifierProvider.notifier)
              .showToast("Selectionner au moins un amis pour partager.");
          return;
        }
        ref
            .read(registerParcourNotifierProvider.notifier)
            .submitParcours(context);
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      // Afficher l'icône de chargement si isLoading est vrai
      icon: isLoading ? null : Icons.check,
      // Si isLoading est vrai, utiliser CircularProgressIndicator, sinon utiliser iconColor normalement
      iconColor: isLoading
          ? Colors.transparent
          : Theme.of(context).colorScheme.onPrimary,
      // Ajouter un CircularProgressIndicator dans le bouton quand isLoading est vrai
      loadingWidget: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : null,
    );
  }
}
