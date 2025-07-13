import 'package:athlete_iq/enums/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/providers/groupe/group_state.dart';
import 'package:athlete_iq/models/group/group_model.dart';

void main() {
  group('GroupState', () {
    test('initial state', () {
      const state = GroupState.initial();
      expect(state, isA<GroupState>());
      expect(state.maybeWhen(initial: () => true, orElse: () => false), isTrue);
    });

    test('loading state', () {
      const state = GroupState.loading();
      expect(state, isA<GroupState>());
      expect(state.maybeWhen(loading: () => true, orElse: () => false), isTrue);
    });

    test('loaded state exposes groups', () {
      final groups = [
        GroupModel(
          creatorUID: "123",
          groupName: "Group 1",
          groupDescription: "Description 1",
          groupImage: "image_url_1",
          groupId: "1",
          lastMessage: "Hello",
          senderUID: "123",
          messageType: MessageEnum.text,
          messageId: "msg_1",
          timeSent: DateTime(2023, 10, 1, 12, 0),
          createdAt: DateTime(2023, 10, 1, 10, 0),
          isPrivate: true,
          editSettings: true,
          membersUIDs: ["123", "456"],
          adminsUIDs: ["123"],
        ),
        GroupModel(
          creatorUID: "456",
          groupName: "Group 2",
          groupDescription: "Description 2",
          groupImage: "image_url_2",
          groupId: "2",
          lastMessage: "Hi",
          senderUID: "456",
          messageType: MessageEnum.text,
          messageId: "msg_2",
          timeSent: DateTime(2023, 10, 2, 12, 0),
          createdAt: DateTime(2023, 10, 2, 10, 0),
          isPrivate: false,
          editSettings: false,
          membersUIDs: ["456", "789"],
          adminsUIDs: ["456"],
        ),
      ];

      final state = GroupState.loaded(groups);

      // on vérifie que c’est bien la bonne variante…
      expect(state.maybeWhen(loaded: (_) => true, orElse: () => false), isTrue);
      // …et que les données internes correspondent
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loaded: (loadedGroups) => expect(loadedGroups, equals(groups)),
        error: (_) => fail('Should not be error'),
      );
    });

    test('error state exposes message', () {
      const errorMessage = "An error occurred";
      const state = GroupState.error(errorMessage);

      expect(state.maybeWhen(error: (_) => true, orElse: () => false), isTrue);

      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loaded: (_) => fail('Should not be loaded'),
        error: (msg) => expect(msg, equals(errorMessage)),
      );
    });
  });
}