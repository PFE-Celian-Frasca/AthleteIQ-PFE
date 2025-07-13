import 'package:flutter_test/flutter_test.dart';

import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/user/user_state.dart';

void main() {
  group('UserState', () {
    test('valeurs par défaut', () {
      const state = UserState();

      expect(state.user, isNull);
      expect(state.error, isNull);
      expect(state.isLoading, isFalse);
      expect(state.currentUser, isNull);
    });

    test('construction avec paramètres + currentUser', () {
      final user = UserModel(
        id: 'u1',
        pseudo: 'Alice',
        email: 'alice@mail.com',
        createdAt: DateTime(2024, 1, 1),
        sex: 'F',
        friends: const [],
        sentFriendRequests: const [],
        receivedFriendRequests: const [],
        fav: const [],
      );

      const errorMsg = 'Oops';

      final state = UserState(
        user: user,
        isLoading: true,
        error: errorMsg,
      );

      expect(state.user, user);
      expect(state.currentUser, same(user)); // getter
      expect(state.isLoading, isTrue);
      expect(state.error, errorMsg);
    });
  });
}