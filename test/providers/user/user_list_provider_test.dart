import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/user/user_list_provider.dart';
import 'package:athlete_iq/services/user_service.dart';

class MockUserService extends Mock implements UserService {}

void main() {
  // fallback générique mocktail
  setUpAll(() {
    registerFallbackValue(<UserModel>[]);
  });

  late MockUserService mockUserService;
  late ProviderContainer container;
  late UserListNotifier notifier;

  // simple factory
  UserModel user(int i) => UserModel(
    id: 'u$i',
    pseudo: 'User$i',
    email: 'u$i@mail.com',
    createdAt: DateTime(2024, 1, i),
    sex: 'M',
    friends: const [],
    sentFriendRequests: const [],
    receivedFriendRequests: const [],
    fav: const [],
  );

  setUp(() {
    mockUserService = MockUserService();
    container = ProviderContainer(
      overrides: [userServiceProvider.overrideWithValue(mockUserService)],
    );
    addTearDown(container.dispose);
    notifier = container.read(userListProvider.notifier);
  });

  group('UserListNotifier', () {
    test('loadUsers success', () async {
      final users = [user(1), user(2)];
      when(() => mockUserService.loadMoreUsers())
          .thenAnswer((_) async => users);

      await notifier.loadUsers();

      final state = container.read(userListProvider);
      expect(state.users, users);
      expect(state.isLoading, isFalse);
      expect(state.hasMore, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('loadUsers error', () async {
      when(() => mockUserService.loadMoreUsers())
          .thenThrow(Exception('network'));

      await notifier.loadUsers();

      final state = container.read(userListProvider);
      expect(state.errorMessage, contains('Exception'));
      expect(state.isLoading, isFalse);
    });

    test('searchUsers success', () async {
      final result = [user(9)];
      when(() => mockUserService.searchUsers(any()))
          .thenAnswer((_) async => result);          // <- any() au lieu de 'Al'

      await notifier.searchUsers('Al');

      final state = container.read(userListProvider);
      expect(state.users, result);
      expect(state.isSearchActive, isTrue);          // <- passe désormais
      expect(state.hasMore, isFalse);
    });

    test('resetPagination remet état initial et relance loadUsers', () async {
      when(() => mockUserService.loadMoreUsers())
          .thenAnswer((_) async => List.generate(10, user));

      await notifier.searchUsers('x'); // active la recherche
      notifier.resetPagination();

      // attend la tâche asynchrone interne
      await container.pump();

      final state = container.read(userListProvider);
      expect(state.users.length, 10);
      expect(state.isSearchActive, isFalse);
      expect(state.hasMore, isTrue);
    });
  });
}