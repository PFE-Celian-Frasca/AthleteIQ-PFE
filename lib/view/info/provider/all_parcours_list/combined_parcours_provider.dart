import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/providers/parcour/parcours_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'combined_parcours_state.dart';

final combinedParcoursProvider =
    StateNotifierProvider<CombinedParcoursNotifier, CombinedParcoursState>(
  (ref) => CombinedParcoursNotifier(ref),
);

class CombinedParcoursNotifier extends StateNotifier<CombinedParcoursState> {
  final Ref _ref;

  CombinedParcoursNotifier(this._ref) : super(const CombinedParcoursState());

  Future<void> getList() async {
    state = state.copyWith(isLoading: true);
    try {
      List<ParcoursWithGPSData> combinedList = [];
      for (var type in [
        ParcoursType.Public,
        ParcoursType.Private,
        ParcoursType.Shared
      ]) {
        var list = await _loadParcours(type);
        combinedList.addAll(list);
      }
      combinedList
          .sort((a, b) => b.parcours.createdAt.compareTo(a.parcours.createdAt));
      state = state.copyWith(isLoading: false, loadedParcours: combinedList);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<List<ParcoursWithGPSData>> _loadParcours(ParcoursType type) async {
    await _ref.read(parcoursProvider.notifier).loadParcours(type: type);
    return _ref.read(parcoursProvider).when(
        initial: () =>
            <ParcoursWithGPSData>[], // Default empty list for initial state
        loading: () =>
            <ParcoursWithGPSData>[], // Default empty list for loading state
        public: (List<ParcoursWithGPSData> publicParcours) {
          print(publicParcours
              .length); // Print the number of loaded parcours (for debugging purposes
          return publicParcours;
        },
        private: (List<ParcoursWithGPSData> privateParcours) {
          print(privateParcours
              .length); // Print the number of loaded parcours (for debugging purposes
          return privateParcours;
        },
        shared: (List<ParcoursWithGPSData> sharedParcours) {
          print(sharedParcours
              .length); // Print the number of loaded parcours (for debugging purposes
          return sharedParcours;
        },
        error: (String message) =>
            <ParcoursWithGPSData>[], // Return an empty list or handle differently if needed
        favorites: (List<ParcoursWithGPSData> favorites) =>
            <ParcoursWithGPSData>[], // Return favorites, or empty if not needed
        parcoursDetails: (ParcoursWithGPSData parcoursDetails) => [
              parcoursDetails
            ] // Return a list containing the single details item
        );
  }

  Future<void> getFavorites() async {
    state = state.copyWith(isLoading: true);
    try {
      List<ParcoursWithGPSData> combinedList = [];

      var list = await _loadFavorites();
      combinedList.addAll(list);
      combinedList
          .sort((a, b) => b.parcours.createdAt.compareTo(a.parcours.createdAt));
      state = state.copyWith(isLoading: false, favoritesParcours: combinedList);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<List<ParcoursWithGPSData>> _loadFavorites() async {
    await _ref.read(parcoursProvider.notifier).loadParcours(favorites: true);
    return _ref.read(parcoursProvider).when(
        initial: () => <ParcoursWithGPSData>[],
        loading: () => <ParcoursWithGPSData>[],
        public: (List<ParcoursWithGPSData> publicParcours) =>
            <ParcoursWithGPSData>[],
        private: (List<ParcoursWithGPSData> privateParcours) =>
            <ParcoursWithGPSData>[],
        shared: (List<ParcoursWithGPSData> sharedParcours) =>
            <ParcoursWithGPSData>[],
        error: (String message) => <ParcoursWithGPSData>[],
        favorites: (List<ParcoursWithGPSData> favorites) {
          print(favorites.length);
          return favorites;
        },
        parcoursDetails: (ParcoursWithGPSData parcoursDetails) => [
              parcoursDetails
            ] // Return a list containing the single details item
        );
  }
}
