import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:athlete_iq/models/group/group_model.dart';
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
      container.listen(groupActionsProvider, (_, next) => states.add(next),
          fireImmediately: true);

      await notifier.createGroup(sampleGroup);

      expect(states[0], const GroupState.initial());
      expect(states[1], const GroupState.loading());
      verify(() => mockGroupService.createGroup(sampleGroup, imageFile: null))
          .called(1);
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

      verify(() => mockNotif.showErrorToast(
          any(that: startsWith('Erreur lors de la création'))))
          .called(1);
    });
  });
}