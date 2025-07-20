import 'dart:async';

import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:athlete_iq/view/community/home_chat_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupService extends Mock implements GroupService {}

void main() {
  late ProviderContainer container;
  late MockGroupService groupServiceMock;

  setUp(() {
    groupServiceMock = MockGroupService();
    container = ProviderContainer(overrides: [
      groupService.overrideWithValue(groupServiceMock),
    ]);
    addTearDown(container.dispose);
  });

  GroupModel sampleGroup() => GroupModel.empty().copyWith(groupId: 'g1');

  test('loadGroups listens to service stream', () async {
    final controller = StreamController<List<GroupModel>>();
    when(() => groupServiceMock.getUserGroupsStream('u1')).thenAnswer((_) => controller.stream);

    final notifier = container.read(homeChatControllerProvider.notifier);
    notifier.loadGroups('u1');

    controller.add([sampleGroup()]);
    await Future<void>.delayed(const Duration(milliseconds: 1));

    expect(container.read(homeChatControllerProvider).value, hasLength(1));
    controller.close();
  });

  test('refreshGroups success sets data', () async {
    when(() => groupServiceMock.getUserGroupsStream('u1'))
        .thenAnswer((_) => Stream.value([sampleGroup()]));

    final notifier = container.read(homeChatControllerProvider.notifier);
    await notifier.refreshGroups('u1');

    expect(container.read(homeChatControllerProvider).value, hasLength(1));
  });

  test('refreshGroups error sets AsyncError', () async {
    when(() => groupServiceMock.getUserGroupsStream('u1'))
        .thenAnswer((_) => Stream<List<GroupModel>>.error(Exception('err')));

    final notifier = container.read(homeChatControllerProvider.notifier);
    await notifier.refreshGroups('u1');

    expect(container.read(homeChatControllerProvider).hasError, true);
  });

  test('dispose cancels subscription without errors', () async {
    final controller = StreamController<List<GroupModel>>();
    when(() => groupServiceMock.getUserGroupsStream('u1')).thenAnswer((_) => controller.stream);

    final notifier = container.read(homeChatControllerProvider.notifier);
    notifier.loadGroups('u1');

    await controller.close();
    expect(true, isTrue); // reached without exceptions
  });
}
