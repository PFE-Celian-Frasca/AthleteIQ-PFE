import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/providers/parcour/single_parcour/single_parcours_state.dart';
import 'package:athlete_iq/services/parcours_service.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final singleParcoursProvider =
    StateNotifierProvider<SingleParcoursNotifier, SingleParcoursState>((ref) {
  return SingleParcoursNotifier(ref);
});

class SingleParcoursNotifier extends StateNotifier<SingleParcoursState> {
  final Ref ref;
  SingleParcoursNotifier(this.ref) : super(const SingleParcoursState.initial());

  Future<void> loadParcoursById(String parcourId) async {
    try {
      state = const SingleParcoursState.loading();
      final parcours =
          await ref.read(parcoursService).getParcoursById(parcourId);
      final gpsData =
          await ref.read(parcoursService).getParcoursGPSData(parcourId);
      final owner =
          await ref.read(userServiceProvider).getUserData(parcours.owner);
      state = SingleParcoursState.loaded(
          ParcoursWithGPSData(parcours: parcours, gpsData: gpsData), owner);
    } catch (e) {
      state = SingleParcoursState.error(e.toString());
    }
  }

  Future<void> updateParcours(ParcoursModel parcours) async {
    try {
      await ref.read(parcoursService).updateParcours(parcours);
      loadParcoursById(parcours.id!); // Reload data
    } catch (e) {
      state = SingleParcoursState.error(e.toString());
    }
  }

  Future<void> deleteParcours(String parcoursId) async {
    try {
      await ref.read(parcoursService).deleteParcours(parcoursId);
      state = const SingleParcoursState.initial();
    } catch (e) {
      state = SingleParcoursState.error(e.toString());
    }
  }
}
