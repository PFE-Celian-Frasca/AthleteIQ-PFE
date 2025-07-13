import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/parcour/location_data_model.dart'; // <-- type GPS
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/parcour/single_parcour/single_parcour_provider.dart';
import 'package:athlete_iq/providers/parcour/single_parcour/single_parcours_state.dart';
import 'package:athlete_iq/services/parcours_service.dart';
import 'package:athlete_iq/services/user_service.dart';

class MockParcoursService extends Mock implements ParcoursService {}
class MockUserService extends Mock implements UserService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      ParcoursModel(
        id: 'fallback',
        owner: 'u0',
        title: 'fallback',
        description: '',
        type: ParcourVisibility.public,
        sportType: SportType.course,
        shareTo: const [],
        timer: const CustomTimer(hours: 0, minutes: 0, seconds: 0),
        createdAt: DateTime.now(),
        vm: 0,
        totalDistance: 0,
        parcoursDataUrl: '',
      ),
    );

    // Fallback pour LocationDataModel si Mocktail en a besoin
    registerFallbackValue(
      const LocationDataModel(latitude: 0.0, longitude: 0.0, time: 0),
    );
  });

  late MockParcoursService mockParcoursService;
  late MockUserService mockUserService;
  late ProviderContainer container;
  late SingleParcoursNotifier notifier;

  // -------------------- fixtures -------------------------------------------
  final dummyParcours = ParcoursModel(
    id: 'p1',
    owner: 'u1',
    title: 'Course',
    description: 'Desc',
    type: ParcourVisibility.public,
    sportType: SportType.course,
    shareTo: const [],
    timer: const CustomTimer(hours: 0, minutes: 10, seconds: 0),
    createdAt: DateTime(2024, 1, 1),
    vm: 10,
    totalDistance: 5,
    parcoursDataUrl: 'https://example.com/parcours_data',
  );

  final dummyGps = <LocationDataModel>[
    const LocationDataModel(latitude: 0.0, longitude: 0.0, time: 0),
    const LocationDataModel(latitude: 1.0, longitude: 1.0, time: 1),
  ];

  final dummyUser = UserModel(
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

  // -------------------------------------------------------------------------
  setUp(() {
    mockParcoursService = MockParcoursService();
    mockUserService = MockUserService();

    container = ProviderContainer(overrides: [
      parcoursService.overrideWithValue(mockParcoursService),
      userServiceProvider.overrideWithValue(mockUserService),
    ]);
    addTearDown(container.dispose);

    notifier = container.read(singleParcoursProvider.notifier);
  });

  group('SingleParcoursNotifier', () {
    test('loadParcoursById → loaded', () async {
      when(() => mockParcoursService.getParcoursById('p1'))
          .thenAnswer((_) async => dummyParcours);
      when(() => mockParcoursService.getParcoursGPSData('p1'))
          .thenAnswer((_) async => dummyGps);
      when(() => mockUserService.getUserData('u1'))
          .thenAnswer((_) async => dummyUser);

      await notifier.loadParcoursById('p1');

      container.read(singleParcoursProvider).when(
        initial: () => fail('should not be initial'),
        loading: () => fail('should not be loading'),
        loaded: (pGps, owner) {
          expect(pGps.parcours, dummyParcours);
          expect(pGps.gpsData, dummyGps);
          expect(owner, dummyUser);
        },
        error: (_) => fail('should not be error'),
      );
    });

    test('loadParcoursById → error', () async {
      when(() => mockParcoursService.getParcoursById('p1'))
          .thenThrow(Exception('db'));

      await notifier.loadParcoursById('p1');

      expect(
        container.read(singleParcoursProvider)
            .maybeWhen(error: (_) => true, orElse: () => false),
        isTrue,
      );
    });

    test('deleteParcours remet à initial', () async {
      when(() => mockParcoursService.deleteParcours('p1'))
          .thenAnswer((_) async {});

      when(() => mockParcoursService.getParcoursById('p1'))
          .thenAnswer((_) async => dummyParcours);
      when(() => mockParcoursService.getParcoursGPSData('p1'))
          .thenAnswer((_) async => dummyGps);
      when(() => mockUserService.getUserData('u1'))
          .thenAnswer((_) async => dummyUser);

      await notifier.loadParcoursById('p1');

      await notifier.deleteParcours('p1');

      expect(container.read(singleParcoursProvider),
          const SingleParcoursState.initial());
    });
  });
}