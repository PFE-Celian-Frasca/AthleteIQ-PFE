import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/providers/groupe/group_details/group_details_provider.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/view/community/chat-page/components/group_info.dart';
import 'package:athlete_iq/enums/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockUserService extends Mock implements UserService {}

class MockGroupActionsNotifier extends Mock implements GroupActionsNotifier {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GroupInfo', () {
    late MockAuthRepository authRepo;
    late MockUser firebaseUser;
    late MockUserService userService;
    late MockGroupActionsNotifier groupActionsNotifier;
    late ProviderContainer container;
    late UserModel testUser;
    late GroupModel testGroup;

    setUp(() {
      authRepo = MockAuthRepository();
      firebaseUser = MockUser();
      userService = MockUserService();
      groupActionsNotifier = MockGroupActionsNotifier();

      when(() => firebaseUser.uid).thenReturn('user1');
      when(() => authRepo.currentUser).thenReturn(firebaseUser);

      testUser = UserModel(
        id: 'user1',
        pseudo: 'Test User',
        email: 'test@example.com',
        sex: 'M',
        image: '', // Empty string to avoid network image loading issues in tests
        createdAt: DateTime(2023, 1, 1),
      );

      testGroup = GroupModel(
        creatorUID: 'user2',
        groupName: 'Test Group',
        groupDescription: 'A test group',
        groupImage: '', // Empty string to avoid network image loading issues in tests
        groupId: 'group1',
        lastMessage: 'Hello',
        senderUID: 'user2',
        messageType: MessageEnum.text,
        messageId: 'msg1',
        timeSent: DateTime(2023, 1, 1, 12, 0),
        createdAt: DateTime(2023, 1, 1),
        isPrivate: false,
        editSettings: true,
        membersUIDs: ['user1', 'user2', 'user3'],
        adminsUIDs: ['user2'],
      );

      // Mock user service to return test user data
      when(() => userService.getUserData(any())).thenAnswer((_) async => testUser);

      // Mock group actions
      when(() => groupActionsNotifier.removeMemberFromGroup(any(), any())).thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepo),
          currentUserProvider('user1').overrideWith((ref) => Future.value(testUser)),
          groupDetailsProvider('group1').overrideWith((ref) => Stream.value(testGroup)),
          userServiceProvider.overrideWithValue(userService),
          groupActionsProvider.overrideWith((ref) => groupActionsNotifier),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders loading state when group details are loading', (tester) async {
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepo),
          currentUserProvider('user1').overrideWith((ref) => Future.value(testUser)),
          groupDetailsProvider('group1').overrideWith((ref) => const Stream.empty()),
          userServiceProvider.overrideWithValue(userService),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (context, child) => const MaterialApp(
              home: GroupInfo('group1'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error state when group details fail to load', (tester) async {
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepo),
          currentUserProvider('user1').overrideWith((ref) => Future.value(testUser)),
          groupDetailsProvider('group1')
              .overrideWith((ref) => Stream.error('Error loading group', StackTrace.empty)),
          userServiceProvider.overrideWithValue(userService),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (context, child) => const MaterialApp(
              home: GroupInfo('group1'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Erreur: Error loading group'), findsOneWidget);
    });
  });
}
