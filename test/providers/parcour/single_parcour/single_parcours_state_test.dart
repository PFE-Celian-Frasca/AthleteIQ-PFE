import 'package:flutter_test/flutter_test.dart';

import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/providers/parcour/single_parcour/single_parcours_state.dart';

void main() {
  // ---------- fixtures rapides -----------------------------------------
  final parcours = ParcoursModel(
    id: 'p1',
    owner: 'u1',
    title: 'Course',
    description: 'Desc',
    type: ParcourVisibility.public,
    sportType: SportType.course,
    shareTo: const [],
    timer: const CustomTimer(hours: 0, minutes: 30, seconds: 0),
    createdAt: DateTime(2024, 1, 1),
    vm: 10,
    totalDistance: 5,
    parcoursDataUrl: '',
  );

  final gps = [
    const LocationDataModel(latitude: 0.0, longitude: 0.0, time: 0),
    const LocationDataModel(latitude: 1.0, longitude: 1.0, time: 10),
  ];

  final owner = UserModel(
    id: 'u1',
    pseudo: 'Alice',
    email: 'a@b.c',
    createdAt: DateTime(2023, 1, 1),
    sex: 'F',
    friends: const [],
    sentFriendRequests: const [],
    receivedFriendRequests: const [],
    fav: const [],
  );

  final parcoursWithGps = ParcoursWithGPSData(parcours: parcours, gpsData: gps);

  //----------------------------------------------------------------------
  group('SingleParcoursState', () {
    test('initial state', () {
      const state = SingleParcoursState.initial();
      expect(state.maybeWhen(initial: () => true, orElse: () => false), isTrue);
    });

    test('loading state', () {
      const state = SingleParcoursState.loading();
      expect(state.maybeWhen(loading: () => true, orElse: () => false), isTrue);
    });

    test('error state exposes message', () {
      const msg = 'oops';
      const state = SingleParcoursState.error(msg);

      expect(state.maybeWhen(error: (_) => true, orElse: () => false), isTrue);
      state.when(
        initial: () => fail('not initial'),
        loading: () => fail('not loading'),
        error: (m) => expect(m, msg),
        loaded: (_, __) => fail('not loaded'),
      );
    });

    test('loaded state exposes data & owner', () {
      final state = SingleParcoursState.loaded(parcoursWithGps, owner);

      expect(state.maybeWhen(loaded: (_, __) => true, orElse: () => false), isTrue);

      state.when(
        initial: () => fail('not initial'),
        loading: () => fail('not loading'),
        error: (_) => fail('not error'),
        loaded: (data, own) {
          expect(data, parcoursWithGps);
          expect(own, owner);
        },
      );
    });
  });
}
