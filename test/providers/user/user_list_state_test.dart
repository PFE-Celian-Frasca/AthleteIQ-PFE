import 'package:flutter_test/flutter_test.dart';

import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/user/user_list_state.dart';

void main() {
  group('UserListState', () {
    test('valeurs par défaut', () {
      const state = UserListState();

      expect(state.users, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.hasMore, isTrue);
      expect(state.isSearchActive, isFalse);
    });

    test('construction personnalisée', () {
      final users = [
        UserModel(
          id: 'u1',
          pseudo: 'Alice',
          email: 'alice@mail.com',
          createdAt: DateTime(2024, 1, 1),
          sex: 'F',
          friends: const [],
          sentFriendRequests: const [],
          receivedFriendRequests: const [],
          fav: const [],
        ),
        UserModel(
          id: 'u2',
          pseudo: 'Bob',
          email: 'bob@mail.com',
          createdAt: DateTime(2024, 2, 2),
          sex: 'M',
          friends: const [],
          sentFriendRequests: const [],
          receivedFriendRequests: const [],
          fav: const [],
        ),
      ];

      const err = 'network down';

      final state = UserListState(
        users: users,
        isLoading: true,
        errorMessage: err,
        hasMore: false,
        isSearchActive: true,
      );

      expect(state.users, equals(users));
      expect(state.isLoading, isTrue);
      expect(state.errorMessage, err);
      expect(state.hasMore, isFalse);
      expect(state.isSearchActive, isTrue);
    });
  });
}