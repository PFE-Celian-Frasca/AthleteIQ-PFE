import 'dart:async';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/parcour_recording/parcours_recording_provider.dart';
import 'package:athlete_iq/providers/timer_provider.dart';
import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:athlete_iq/utils/parcour_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'register_parcour_state.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';

class RegisterParcourNotifier extends StateNotifier<RegisterParcourState> {
  final Ref ref;
  late final StreamSubscription<UserModel?> _userSubscription;

  RegisterParcourNotifier(this.ref) : super(const RegisterParcourState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    await _initUserData();
    await _initParcourData();
    state = state.copyWith(isLoading: false);
  }

  Future<void> _initUserData() async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      ref
          .read(internalNotificationProvider)
          .showErrorToast("Utilisateur non authentifié.");
      state = state.copyWith(isLoading: false);
      return;
    }

    final userId = currentUser.uid;
    _userSubscription = ref
        .read(userRepositoryProvider)
        .userStateChanges(userId: userId)
        .listen(
      (user) async {
        state = state.copyWith(owner: user);
        await _initFriends();
      },
      onError: (e) {
        ref
            .read(internalNotificationProvider)
            .showErrorToast("Erreur lors du chargement de l'utilisateur");
      },
    );
  }

  Future<void> _initFriends() async {
    final user = state.owner;
    if (user == null) return;

    try {
      List<UserModel> friendsDetails = [];
      for (String friendId in user.friends) {
        final friend =
            await ref.read(userRepositoryProvider).getUserData(friendId);
        friendsDetails.add(friend);
      }
      state = state.copyWith(friends: friendsDetails);
    } catch (e) {
      ref
          .read(internalNotificationProvider)
          .showErrorToast("Erreur lors du chargement des amis");
    }
  }

  Future<void> _initParcourData() async {
    List<LocationData> locationData =
        ref.watch(parcoursRecordingNotifierProvider).recordedLocations;
    if (locationData.isEmpty) {
      return;
    }

    List<LocationDataModel> locationDataModel =
        locationDataToLocationDataModel(locationData);

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
      averageSpeed: averageSpeed,
    );
  }

  void setTitle(String? title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String? description) {
    state = state.copyWith(description: description);
  }

  void setParcourType(ParcourVisibility type) {
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

  Future<void> submitParcours(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    if (state.title == null || state.title!.isEmpty) {
      ref
          .read(internalNotificationProvider)
          .showErrorToast("Veuillez entrer un titre");
      state = state.copyWith(isLoading: false);
      return;
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
      await ref
          .read(parcoursRepositoryProvider)
          .addParcours(newParcours, state.recordedLocations);

      // Update user's total distance
      final user = state.owner;
      if (user != null) {
        final updatedTotalDistance =
            (user.totalDist) + (state.totalDistance ?? 0);
        final updatedUser = user.copyWith(totalDist: updatedTotalDistance);
        await ref.read(userRepositoryProvider).updateUser(updatedUser);
      }

      ref
          .read(internalNotificationProvider)
          .showToast("Parcours enregistré avec succès.");
      if (context.mounted) {
        GoRouter.of(context).pop();
      }
    } catch (e) {
      ref
          .read(internalNotificationProvider)
          .showErrorToast("Échec de l'enregistrement du parcours: $e");
      state = state.copyWith(isLoading: false);
      return;
    }
    state = state.copyWith(isLoading: false);
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}

final registerParcourNotifierProvider =
    StateNotifierProvider<RegisterParcourNotifier, RegisterParcourState>(
        (ref) => RegisterParcourNotifier(ref));
