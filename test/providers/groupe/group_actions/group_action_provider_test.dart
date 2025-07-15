import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/providers/groupe/group_state.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';

class MockGroupService extends Mock implements GroupService {}

class MockNotifService extends Mock implements InternalNotificationService {}

void main() {
  setUpAll(() {
    registerFallbackValue(File('dummy'));

    // fallback pour GroupModel (valeurs minimalistes)
    registerFallbackValue(
      GroupModel(
        creatorUID: '',
        groupName: '',
        groupDescription: '',
        groupImage: '',
        groupId: '',
        lastMessage: '',
        senderUID: '',
        messageType: MessageEnum.text,
        messageId: '',
        timeSent: DateTime.now(),
        createdAt: DateTime.now(),
        isPrivate: false,
        editSettings: false,
        membersUIDs: [],
        adminsUIDs: [],
      ),
    );
  });

  late MockGroupService mockGroupService;
  late MockNotifService mockNotif;
  late ProviderContainer container;
  late GroupModel sampleGroup;

  setUp(() {
    mockGroupService = MockGroupService();
    mockNotif = MockNotifService();

    container = ProviderContainer(overrides: [
      groupService.overrideWithValue(mockGroupService),
      internalNotificationProvider.overrideWithValue(mockNotif),
    ]);
    addTearDown(container.dispose);

    sampleGroup = GroupModel(
      creatorUID: '123',
      groupName: 'New Group',
      groupDescription: 'desc',
      groupImage: '',
      groupId: 'g1',
      lastMessage: '',
      senderUID: '',
      messageType: MessageEnum.text,
      messageId: '',
      timeSent: DateTime.now(),
      createdAt: DateTime.now(),
      isPrivate: false,
      editSettings: false,
      membersUIDs: ['123'],
      adminsUIDs: ['123'],
    );
  });

  group('GroupActionsNotifier', () {
    test('createGroup succès ⇒ state.loading puis appel service', () async {
      when(() => mockGroupService.createGroup(sampleGroup, imageFile: null))
          .thenAnswer((_) async {});

      final notifier = container.read(groupActionsProvider.notifier);

      final states = <GroupState>[];
      container.listen(groupActionsProvider, (_, next) => states.add(next), fireImmediately: true);

      await notifier.createGroup(sampleGroup);

      expect(states[0], const GroupState.initial());
      expect(states[1], const GroupState.loading());
      verify(() => mockGroupService.createGroup(sampleGroup, imageFile: null)).called(1);
      verifyNever(() => mockNotif.showErrorToast(any()));
    });

    test('createGroup erreur ⇒ state.error + toast', () async {
      when(() => mockGroupService.createGroup(sampleGroup, imageFile: null))
          .thenThrow(Exception('db error'));

      final notifier = container.read(groupActionsProvider.notifier);

      await expectLater(
        () => notifier.createGroup(sampleGroup),
        throwsA(isA<Exception>()),
      );

      final state = container.read(groupActionsProvider);
      state.when(
        error: (msg) => expect(msg, contains('db error')),
        loading: () => fail('should not be in loading state'),
        initial: () => fail('should not be in initial state'),
        loaded: (_) => fail('should not reach loaded'),
      );

      verify(() => mockNotif.showErrorToast(any(that: startsWith('Erreur lors de la création'))))
          .called(1);
    });

    test('updateGroup succès ⇒ appel service', () async {
      when(() => mockGroupService.updateGroup(sampleGroup)).thenAnswer((_) async {});

      final notifier = container.read(groupActionsProvider.notifier);
      await notifier.updateGroup(sampleGroup, '123');

      expect(container.read(groupActionsProvider), const GroupState.initial());
      verify(() => mockGroupService.updateGroup(sampleGroup)).called(1);
      verifyNever(() => mockNotif.showErrorToast(any()));
    });

    test('updateGroup erreur ⇒ state.error + toast', () async {
      when(() => mockGroupService.updateGroup(sampleGroup)).thenThrow(Exception('fail'));

      final notifier = container.read(groupActionsProvider.notifier);

      await expectLater(() => notifier.updateGroup(sampleGroup, '123'), throwsA(isA<Exception>()));

      container.read(groupActionsProvider).when(
            error: (msg) => expect(msg, contains('fail')),
            loading: () => fail('should not be loading'),
            initial: () => fail('should not be initial'),
            loaded: (_) => fail('should not reach loaded'),
          );

      verify(() => mockNotif.showErrorToast(any(that: contains('mise à jour')))).called(1);
    });

    test('leaveGroup succès ⇒ mise à jour membres', () async {
      when(() => mockGroupService.updateGroup(any())).thenAnswer((_) async {});

      final notifier = container.read(groupActionsProvider.notifier);
      await notifier.leaveGroup(group: sampleGroup, currentUser: UserModel(
        id: '123',
        pseudo: 'p',
        email: 'e',
        createdAt: DateTime.now(),
        sex: 'M',
      ));

      verify(() => mockGroupService.updateGroup(any())).called(1);
      verifyNever(() => mockNotif.showErrorToast(any()));
    });

    test('leaveGroup erreur ⇒ state.error + toast', () async {
      when(() => mockGroupService.updateGroup(any())).thenThrow(Exception('leave'));

      final notifier = container.read(groupActionsProvider.notifier);

      await expectLater(
        () => notifier.leaveGroup(group: sampleGroup, currentUser: UserModel(
          id: '123',
          pseudo: 'p',
          email: 'e',
          createdAt: DateTime.now(),
          sex: 'M',
        )),
        throwsA(isA<Exception>()),
      );

      verify(() => mockNotif.showErrorToast(any(that: contains('sortie')))).called(1);
    });

    test('joinGroup succès ⇒ mise à jour membres', () async {
      when(() => mockGroupService.updateGroup(any())).thenAnswer((_) async {});

      final notifier = container.read(groupActionsProvider.notifier);
      await notifier.joinGroup(group: sampleGroup, currentUser: UserModel(
        id: '456',
        pseudo: 'x',
        email: 'x@x.com',
        createdAt: DateTime.now(),
        sex: 'F',
      ));

      verify(() => mockGroupService.updateGroup(any())).called(1);
      verifyNever(() => mockNotif.showErrorToast(any()));
    });

    test('joinGroup erreur ⇒ state.error + toast', () async {
      when(() => mockGroupService.updateGroup(any())).thenThrow(Exception('join'));

      final notifier = container.read(groupActionsProvider.notifier);

      await expectLater(
        () => notifier.joinGroup(group: sampleGroup, currentUser: UserModel(
          id: '456',
          pseudo: 'x',
          email: 'x@x.com',
          createdAt: DateTime.now(),
          sex: 'F',
        )),
        throwsA(isA<Exception>()),
      );

      verify(() => mockNotif.showErrorToast(any(that: contains("ajout")))).called(1);
    });

    test('removeMemberFromGroup succès', () async {
      when(() => mockGroupService.removeMemberFromGroup('g1', 'u2')).thenAnswer((_) async {});

      final notifier = container.read(groupActionsProvider.notifier);
      await notifier.removeMemberFromGroup('g1', 'u2');

      verify(() => mockGroupService.removeMemberFromGroup('g1', 'u2')).called(1);
      verifyNever(() => mockNotif.showErrorToast(any()));
    });

    test('removeMemberFromGroup erreur ⇒ state.error + toast', () async {
      when(() => mockGroupService.removeMemberFromGroup('g1', 'u2')).thenThrow(Exception('remove'));

      final notifier = container.read(groupActionsProvider.notifier);

      await expectLater(() => notifier.removeMemberFromGroup('g1', 'u2'), throwsA(isA<Exception>()));

      verify(() => mockNotif.showErrorToast(any(that: contains('suppression du membre')))).called(1);
    });

    test('deleteGroup succès ⇒ toast de confirmation', () async {
      when(() => mockGroupService.deleteGroup('g1')).thenAnswer((_) async {});

      final notifier = container.read(groupActionsProvider.notifier);
      await notifier.deleteGroup('g1');

      verify(() => mockGroupService.deleteGroup('g1')).called(1);
      verify(() => mockNotif.showToast(any())).called(1);
    });

    test('deleteGroup erreur ⇒ state.error + toast', () async {
      when(() => mockGroupService.deleteGroup('g1')).thenThrow(Exception('del'));

      final notifier = container.read(groupActionsProvider.notifier);

      await expectLater(() => notifier.deleteGroup('g1'), throwsA(isA<Exception>()));

      verify(() => mockNotif.showErrorToast(any(that: contains('suppression du groupe')))).called(1);
    });
  });
}
