import 'package:athlete_iq/providers/parcour_recording/parcours_recording_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/parcour/location_data_model.dart';
import '../../models/parcour/parcours_model.dart';
import '../../models/parcour/parcours_with_gps_data.dart';
import '../../services/parcours_service.dart';
import '../user/user_provider.dart';
import 'parcours_state.dart';

final parcoursProvider =
    StateNotifierProvider<ParcoursNotifier, ParcoursState>((ref) {
  return ParcoursNotifier(ref.read(parcoursService), ref);
});

class ParcoursNotifier extends StateNotifier<ParcoursState> {
  final ParcoursService _parcoursService;
  final Ref _ref;
  ParcoursNotifier(this._parcoursService, this._ref)
      : super(const ParcoursState.initial());

  Future<void> addParcours(
      ParcoursModel parcours, List<LocationDataModel> locationData) async {
    state = const ParcoursState.loading();
    try {
      await _parcoursService.addParcours(parcours, locationData);
      loadParcours(type: parcours.type).then((value) => _ref
          .read(parcoursRecordingNotifierProvider.notifier)
          .clearRecordedLocations());
    } catch (e) {
      state = ParcoursState.error(e.toString());
    }
  }

  Future<void> deleteParcours(ParcoursModel parcour) async {
    state = const ParcoursState.loading();
    try {
      await _parcoursService.deleteParcours(parcour.id!);
      loadParcours(type: parcour.type);
    } catch (e) {
      state = ParcoursState.error(e.toString());
    }
  }

  Future<void> deleteAllParcoursForUser(String userId) async {
    state = const ParcoursState.loading();
    try {
      await _parcoursService.deleteAllParcoursForUser(userId);
      state = const ParcoursState.favorites([]);
      state = const ParcoursState.private([]);
      state = const ParcoursState.public([]);
      state = const ParcoursState.shared([]);
    } catch (e) {
      state = ParcoursState.error(e.toString());
      rethrow;
    }
  }

  Future<void> updateParcours(ParcoursModel updatedParcours) async {
    state = const ParcoursState.loading();
    try {
      await _parcoursService.updateParcours(updatedParcours);
      loadParcours(type: updatedParcours.type);
    } catch (e) {
      state = ParcoursState.error(e.toString());
    }
  }

  Future<void> loadParcours(
      {ParcoursType? type, bool favorites = false}) async {
    state = const ParcoursState.loading();
    try {
      final user = _ref.read(userProvider).whenOrNull(loaded: (user) => user);
      List<ParcoursModel> parcours = favorites
          ? await _parcoursService.getFavorites(user!)
          : await _parcoursService
              .getParcoursByType(type ?? ParcoursType.Public, userId: user?.id);

      List<ParcoursWithGPSData> parcoursListWithDetails =
          await Future.wait(parcours.map((parcours) async {
        final gpsData = await _parcoursService.getParcoursGPSData(parcours.id!);
        return ParcoursWithGPSData(parcours: parcours, gpsData: gpsData);
      }));
      switch (type) {
        case ParcoursType.Public:
          state = ParcoursState.public(parcoursListWithDetails);
          parcours.clear();
          break;
        case ParcoursType.Private:
          state = ParcoursState.private(parcoursListWithDetails);
          parcours.clear();
          break;
        case ParcoursType.Shared:
          state = ParcoursState.shared(parcoursListWithDetails);
          parcours.clear();
          break;
        default:
          if (favorites) {
            state = ParcoursState.favorites(parcoursListWithDetails);
          } else {
            state = const ParcoursState.error("Unknown parcours type");
          }
          break;
      }
    } catch (e) {
      state = ParcoursState.error(e.toString());
    }
  }

  Future<void> loadParcoursById(String parcoursId) async {
    try {
      final parcour = await _parcoursService.getParcoursById(parcoursId);
      final parcourData = await _parcoursService.getParcoursGPSData(parcoursId);
      final parcourWithGpsData =
          ParcoursWithGPSData(parcours: parcour, gpsData: parcourData);
      state = ParcoursState.parcoursDetails(parcourWithGpsData);
      state = const ParcoursState.loading();
    } catch (e) {
      state = ParcoursState.error(e.toString());
    }
  }
}
