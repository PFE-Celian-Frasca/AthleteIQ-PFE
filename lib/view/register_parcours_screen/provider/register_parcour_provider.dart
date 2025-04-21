import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';

import 'package:athlete_iq/providers/parcour/parcours_provider.dart';
import 'package:athlete_iq/providers/parcour_recording/parcours_recording_provider.dart';
import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:athlete_iq/providers/user/user_state.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_provider.dart';
import 'package:athlete_iq/utils/parcour_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'register_parcour_state.dart';

class RegisterParcourNotifier extends StateNotifier<RegisterParcourState> {
  final Ref ref;

  RegisterParcourNotifier(this.ref) : super(const RegisterParcourState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    await _initUserData();
    await _initFriends();
    await _initParcourData();
    state = state.copyWith(isLoading: false);
  }

  void setTitle(String? title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String? description) {
    state = state.copyWith(description: description);
  }

  void setParcourType(ParcoursType type) {
    state = state.copyWith(parcourType: type);
  }

  void addFriendToShare(String friendId) {
    state = state.copyWith(friendsToShare: [...state.friendsToShare, friendId]);
  }

  void removeFriendToShare(String friendId) {
    state = state.copyWith(
      friendsToShare:
          state.friendsToShare.where((id) => id != friendId).toList(),
    );
  }

  Future<void> _initParcourData() async {
    // Fetching recorded locations from the state
    List<LocationData> locationData =
        ref.watch(parcoursRecordingNotifierProvider).recordedLocations;
    if (locationData.isEmpty) {
      return;
    }

    List<LocationDataModel> locationDataModel =
        locationDataToLocationDataModel(locationData);

    // Compute values
    double totalDistance = calculateTotalDistance(locationDataModel);

    double? maxAltitude = calculateMaxAltitude(locationDataModel);

    double? minAltitude = calculateMinAltitude(locationDataModel);

    double elevationGain = calculateTotalElevationGain(locationDataModel);

    double elevationLoss = calculateTotalElevationLoss(locationDataModel);

    double minSpeed = calculateMinSpeed(locationDataModel);

    double maxSpeed = calculateMaxSpeed(locationDataModel);

    double averageSpeed = calculateAverageSpeed(
        totalDistance: totalDistance, timer: ref.read(timerProvider));

    state = state.copyWith(
        recordedLocations: locationDataModel,
        totalDistance: totalDistance,
        maxAltitude: maxAltitude,
        minAltitude: minAltitude,
        elevationGain: elevationGain,
        elevationLoss: elevationLoss,
        minSpeed: minSpeed,
        maxSpeed: maxSpeed,
        averageSpeed: averageSpeed);
  }

  Future<void> _initFriends() async {
    List<UserModel> friendsDetails = [];
    if (state.owner == null) {
      return;
    } else {
      for (String friendId in state.owner!.friends) {
        try {
          UserModel friend =
              await ref.read(userServiceProvider).getUserData(friendId);
          friendsDetails.add(friend);
        } catch (e) {
          ref
              .read(notificationNotifierProvider.notifier)
              .showErrorToast("Erreur lors du chargement des amis");
        }
      }
    }
    state = state.copyWith(friends: friendsDetails);
  }

  Future<void> _initUserData() async {
    final userState = ref.read(globalProvider).userState;

    if (userState is Loaded) {
      state = state.copyWith(owner: userState.user);
    } else {}
  }

  // Method to submit parcour data
  Future<void> submitParcours(BuildContext context) async {
    if (state.title == null || state.title!.isEmpty) {
      ref
          .read(notificationNotifierProvider.notifier)
          .showErrorToast("Veuillez entrer un titre");
      return; // Ensure title is not empty
    }

    ParcoursModel newParcours = ParcoursModel(
      owner: state.owner?.id ?? 'unknown',
      title: state.title!,
      description: state.description,
      type: state.parcourType,
      sportType: state.sportType,
      shareTo: state.friendsToShare,
      createdAt: DateTime.now(),
      totalDistance: state.totalDistance ?? 0,
      vm: state.averageSpeed ?? 0,
      timer: CustomTimer(
        hours: ref.read(timerProvider).hours,
        minutes: ref.read(timerProvider).minutes,
        seconds: ref.read(timerProvider).seconds,
      ),
    );

    try {
      // Assuming parcoursProvider is set up to handle adding a ParcoursModel
      print("bite");
      await ref
          .read(parcoursProvider.notifier)
          .addParcours(newParcours, state.recordedLocations)
          .then((value) => GoRouter.of(context).pop());
    } catch (e) {
      return;
    }
  }
}

final registerParcourNotifierProvider =
    StateNotifierProvider<RegisterParcourNotifier, RegisterParcourState>(
  (ref) => RegisterParcourNotifier(ref),
);
