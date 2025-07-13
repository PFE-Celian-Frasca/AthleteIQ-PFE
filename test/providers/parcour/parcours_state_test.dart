import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/providers/parcour/parcours_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';

void main() {
  group('ParcoursState', () {
    final dummy = ParcoursWithGPSData(
      parcours: ParcoursModel(
          owner: "dummyOwner",
          title: "Dummy Parcours",
          type: ParcourVisibility.public,
          sportType: SportType.course,
          shareTo: ["dummyShare"],
          timer: const CustomTimer(
            hours: 1,
            minutes: 30,
            seconds: 45,
          ),
          createdAt: DateTime(2023, 10, 1),
          vm: 100.0,
          totalDistance: 100.0,
      ),
      gpsData: [],
    );

    test('initial state', () {
      const state = ParcoursState.initial();
      expect(state, isA<ParcoursState>());
      expect(state.maybeWhen(initial: () => true, orElse: () => false), isTrue);
    });

    test('loading state', () {
      const state = ParcoursState.loading();
      expect(state, isA<ParcoursState>());
      expect(state.maybeWhen(loading: () => true, orElse: () => false), isTrue);
    });

    test('public state exposes parcours list', () {
      final list = [dummy];
      final state = ParcoursState.public(list);

      expect(state.maybeWhen(public: (_) => true, orElse: () => false), isTrue);

      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        public: (p) => expect(p, equals(list)),
        private: (_) => fail('Should not be private'),
        shared: (_) => fail('Should not be shared'),
        error: (_) => fail('Should not be error'),
        favorites: (_) => fail('Should not be favorites'),
        parcoursDetails: (_) => fail('Should not be details'),
      );
    });

    test('private state exposes parcours list', () {
      final list = [dummy];
      final state = ParcoursState.private(list);

      expect(state.maybeWhen(private: (_) => true, orElse: () => false), isTrue);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        public: (_) => fail('Should not be public'),
        private: (p) => expect(p, equals(list)),
        shared: (_) => fail('Should not be shared'),
        error: (_) => fail('Should not be error'),
        favorites: (_) => fail('Should not be favorites'),
        parcoursDetails: (_) => fail('Should not be details'),
      );
    });

    test('shared state exposes parcours list', () {
      final list = [dummy];
      final state = ParcoursState.shared(list);

      expect(state.maybeWhen(shared: (_) => true, orElse: () => false), isTrue);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        public: (_) => fail('Should not be public'),
        private: (_) => fail('Should not be private'),
        shared: (p) => expect(p, equals(list)),
        error: (_) => fail('Should not be error'),
        favorites: (_) => fail('Should not be favorites'),
        parcoursDetails: (_) => fail('Should not be details'),
      );
    });

    test('favorites state exposes parcours list', () {
      final list = [dummy];
      final state = ParcoursState.favorites(list);

      expect(state.maybeWhen(favorites: (_) => true, orElse: () => false), isTrue);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        public: (_) => fail('Should not be public'),
        private: (_) => fail('Should not be private'),
        shared: (_) => fail('Should not be shared'),
        error: (_) => fail('Should not be error'),
        favorites: (f) => expect(f, equals(list)),
        parcoursDetails: (_) => fail('Should not be details'),
      );
    });

    test('parcoursDetails state exposes a single parcours', () {
      final state = ParcoursState.parcoursDetails(dummy);

      expect(state.maybeWhen(parcoursDetails: (_) => true, orElse: () => false), isTrue);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        public: (_) => fail('Should not be public'),
        private: (_) => fail('Should not be private'),
        shared: (_) => fail('Should not be shared'),
        error: (_) => fail('Should not be error'),
        favorites: (_) => fail('Should not be favorites'),
        parcoursDetails: (p) => expect(p, equals(dummy)),
      );
    });

    test('error state exposes message', () {
      const message = 'An error occurred';
      const state = ParcoursState.error(message);

      expect(state.maybeWhen(error: (_) => true, orElse: () => false), isTrue);
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        public: (_) => fail('Should not be public'),
        private: (_) => fail('Should not be private'),
        shared: (_) => fail('Should not be shared'),
        error: (msg) => expect(msg, equals(message)),
        favorites: (_) => fail('Should not be favorites'),
        parcoursDetails: (_) => fail('Should not be details'),
      );
    });
  });
}