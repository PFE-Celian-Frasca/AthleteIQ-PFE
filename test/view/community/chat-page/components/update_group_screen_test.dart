// test/view/community/chat-page/components/update_group_screen_test.dart
import 'dart:async';

import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart'
    show groupActionsProvider, GroupActionsNotifier;
import 'package:athlete_iq/providers/groupe/group_details/group_details_provider.dart';
import 'package:athlete_iq/providers/groupe/group_state.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/resources/components/Button/custom_elevated_button.dart';
import 'package:athlete_iq/resources/components/ConfirmationDialog/custom_confirmation_dialog.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/view/community/chat-page/components/custom_animated_toggle.dart';
import 'package:athlete_iq/view/community/chat-page/components/generic_list_component.dart';
import 'package:athlete_iq/view/community/chat-page/components/update_group_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// ---------------- Fakes simples ----------------

class _FakeUser implements User {
  @override
  String get uid => 'me';
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthRepo implements AuthRepository {
  final _u = _FakeUser();
  @override
  User? get currentUser => _u;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUserService implements UserService {
  final UserModel _base = UserModel(
    id: 'me',
    pseudo: 'Me',
    email: 'me@ex.com',
    sex: 'M',
    createdAt: DateTime(2024, 1, 1),
  );

  @override
  Future<UserModel> getUserData(String userId) async =>
      _base.copyWith(id: userId, pseudo: 'User $userId');

  @override
  Stream<List<UserModel>> listAllUsersStream() async* {
    yield <UserModel>[
      _base.copyWith(id: 'me', pseudo: 'User me'),
      _base.copyWith(id: 'u2', pseudo: 'User u2'),
      _base.copyWith(id: 'u3', pseudo: 'User u3'),
    ];
  }


  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ---- Fake notifier basé sur ton vrai constructeur GroupActionsNotifier(Ref) ----
class _FakeGroupActionsNotifier extends GroupActionsNotifier {
  _FakeGroupActionsNotifier(super.ref, {GroupState? initial}) {
    state = initial ?? const GroupState.initial();
  }

  int updateCalls = 0;
  int deleteCalls = 0;
  GroupModel? lastUpdatedGroup;
  String? lastUpdatedByUserId;
  String? lastDeletedGroupId;

  @override
  Future<void> updateGroup(GroupModel group, String userId) async {
    updateCalls++;
    lastUpdatedGroup = group;
    lastUpdatedByUserId = userId;
    state = const GroupState.loading();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    state = const GroupState.initial();
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    deleteCalls++;
    lastDeletedGroupId = groupId;
    state = const GroupState.loading();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    state = const GroupState.initial();
  }
}

// ---------------- Helpers ----------------

GroupModel _group({
  String id = 'g1',
  String name = 'Mon groupe',
  bool isPrivate = false,
  List<String> members = const ['me', 'u2'],
}) {
  final now = DateTime(2024, 1, 1, 12);
  return GroupModel(
    creatorUID: 'me',
    groupName: name,
    groupDescription: 'desc',
    groupImage: '',
    groupId: id,
    lastMessage: '',
    senderUID: 'me',
    messageType: MessageEnum.text,
    messageId: 'm0',
    timeSent: now,
    createdAt: now,
    isPrivate: isPrivate,
    editSettings: true,
    membersUIDs: members,
    adminsUIDs: const ['me'],
  );
}

Future<
    ({
      _FakeGroupActionsNotifier actions,
    })> _pumpBasic(
  WidgetTester tester, {
  required String groupId,
  required Stream<GroupModel> groupDetailsStream,
  GroupState? actionsInitialState,
}) async {
  late _FakeGroupActionsNotifier actions;

  final currentUser = UserModel(
    id: 'me',
    pseudo: 'Me',
    email: 'me@ex.com',
    sex: 'M',
    createdAt: DateTime(2024, 1, 1),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(_FakeAuthRepo()),
        currentUserProvider('me').overrideWith((ref) => currentUser),
        groupDetailsProvider(groupId).overrideWith((ref) => groupDetailsStream),
        groupActionsProvider.overrideWith((ref) {
          actions = _FakeGroupActionsNotifier(ref, initial: actionsInitialState);
          return actions;
        }),
        userServiceProvider.overrideWithValue(_FakeUserService()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, __) => MaterialApp(
          home: UpdateGroupScreen(groupId: groupId),
        ),
      ),
    ),
  );

  await tester.pump();
  return (actions: actions);
}

/// Variante avec GoRouter pour tester la navigation après "Supprimer".
Future<
    ({
      _FakeGroupActionsNotifier actions,
      GoRouter router,
    })> _pumpWithRouter(
  WidgetTester tester, {
  required String groupId,
  required Stream<GroupModel> groupDetailsStream,
}) async {
  late _FakeGroupActionsNotifier actions;

  final currentUser = UserModel(
    id: 'me',
    pseudo: 'Me',
    email: 'me@ex.com',
    sex: 'M',
    createdAt: DateTime(2024, 1, 1),
  );

  final router = GoRouter(
    initialLocation: '/update/$groupId',
    routes: [
      GoRoute(
        path: '/update/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(_FakeAuthRepo()),
              currentUserProvider('me').overrideWith((ref) => currentUser),
              groupDetailsProvider(id).overrideWith((ref) => groupDetailsStream),
              groupActionsProvider.overrideWith((ref) {
                actions = _FakeGroupActionsNotifier(ref);
                return actions;
              }),
              userServiceProvider.overrideWithValue(_FakeUserService()),
            ],
            child: ScreenUtilInit(
              designSize: const Size(360, 690),
              builder: (_, __) => UpdateGroupScreen(groupId: id),
            ),
          );
        },
      ),
      GoRoute(
        path: '/groups',
        builder: (_, __) => const Scaffold(body: Center(child: Text('Groups page'))),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const Scaffold(body: Center(child: Text('Root'))),
      ),
    ],
  );

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
  return (actions: actions, router: router);
}

// ---------------- Tests ----------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UpdateGroupScreen — états de base', () {
    testWidgets('affiche un loader tant que groupDetails n’a pas émis', (tester) async {
      final ctrl = StreamController<GroupModel>();
      await _pumpBasic(
        tester,
        groupId: 'g1',
        groupDetailsStream: ctrl.stream,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await ctrl.close();
    });

    testWidgets('affiche une erreur quand groupDetails émet une erreur', (tester) async {
      await _pumpBasic(
        tester,
        groupId: 'g1',
        groupDetailsStream: Stream<GroupModel>.error('boom'),
      );
      expect(find.textContaining('Erreur'), findsOneWidget);
    });

    testWidgets('affiche une erreur quand currentUser échoue', (tester) async {
      final g = _group();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_FakeAuthRepo()),
            currentUserProvider('me').overrideWith((ref) => throw 'boom'),
            groupDetailsProvider('g1').overrideWith((ref) => Stream.value(g)),
            userServiceProvider.overrideWithValue(_FakeUserService()),
            groupActionsProvider.overrideWith((ref) => _FakeGroupActionsNotifier(ref)),
          ],
          child: ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (_, __) => const MaterialApp(
              home: UpdateGroupScreen(groupId: 'g1'),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Erreur'), findsOneWidget);
    });
  });

  testWidgets(
    'section privee toggleUser ajoute PUIS retire un membre et updateGroup reflete la liste',
    (tester) async {
      // Groupe initial privé avec "me" et "u2"
      final g = _group(isPrivate: true, members: const ['me', 'u2']);
      final setup = await _pumpBasic(
        tester,
        groupId: 'g1',
        groupDetailsStream: Stream.value(g),
      );

      // La section privée est visible et GenericListComponent est bien monté
      final listFinder = find.byType(GenericListComponent<UserModel>);
      expect(listFinder, findsOneWidget);

      // 1) Ajout de u3
      var listWidget = tester.widget<GenericListComponent<UserModel>>(listFinder);
      final u3 = UserModel(
        id: 'u3',
        pseudo: 'User u3',
        email: 'u3@ex.com',
        sex: 'F',
        createdAt: DateTime(2024, 1, 1),
      );
      listWidget.onItemSelected(u3); // => toggleUser(u3) => ajout
      await tester.pump();

      await tester.tap(find.widgetWithText(CustomElevatedButton, 'Modifier'));
      await tester.pump(const Duration(milliseconds: 20));

      expect(setup.actions.updateCalls, 1);
      expect(setup.actions.lastUpdatedGroup, isNotNull);
      expect(setup.actions.lastUpdatedGroup!.membersUIDs, contains('u3'));

      // 2) Retrait de u3
      listWidget = tester.widget<GenericListComponent<UserModel>>(listFinder);
      listWidget.onItemSelected(u3); // => toggleUser(u3) => retrait
      await tester.pump();

      await tester.tap(find.widgetWithText(CustomElevatedButton, 'Modifier'));
      await tester.pump(const Duration(milliseconds: 20));

      expect(setup.actions.updateCalls, 2);
      expect(setup.actions.lastUpdatedGroup!.membersUIDs, isNot(contains('u3')));
    },
  );

  group('UpdateGroupScreen — actions & interactions', () {
    testWidgets('bouton retour (close) fait un pop', (tester) async {
      // On crée une page racine avec un bouton qui PUSH l’écran testé,
      // ainsi le pop possède bien une route précédente où revenir.
      final g = _group();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  child: const Text('GO'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ProviderScope(
                          overrides: [
                            authRepositoryProvider.overrideWithValue(_FakeAuthRepo()),
                            currentUserProvider('me').overrideWith((ref) => UserModel(
                                  id: 'me',
                                  pseudo: 'Me',
                                  email: 'me@ex.com',
                                  sex: 'M',
                                  createdAt: DateTime(2024, 1, 1),
                                )),
                            groupDetailsProvider('g1').overrideWith((ref) => Stream.value(g)),
                            userServiceProvider.overrideWithValue(_FakeUserService()),
                            groupActionsProvider
                                .overrideWith((ref) => _FakeGroupActionsNotifier(ref)),
                          ],
                          child: ScreenUtilInit(
                            designSize: const Size(360, 690),
                            builder: (_, __) => const UpdateGroupScreen(groupId: 'g1'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Push l’écran
      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();

      // On est sur UpdateGroupScreen
      expect(find.byType(UpdateGroupScreen), findsOneWidget);

      // Tap sur "close"
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Retour à la page racine
      expect(find.byType(UpdateGroupScreen), findsNothing);
      expect(find.text('GO'), findsOneWidget);
    });

    testWidgets('isLoading (GroupState.loading) désactive les boutons', (tester) async {
      final g = _group();
      final setup = await _pumpBasic(
        tester,
        groupId: 'g1',
        groupDetailsStream: Stream.value(g),
        actionsInitialState: const GroupState.loading(),
      );

      final editBtnFinder = find.widgetWithText(CustomElevatedButton, 'Modifier');
      final delBtnFinder = find.widgetWithText(CustomElevatedButton, 'Supprimer le groupe');
      expect(editBtnFinder, findsOneWidget);
      expect(delBtnFinder, findsOneWidget);

      await tester.tap(editBtnFinder);
      await tester.tap(delBtnFinder);
      await tester.pump(const Duration(milliseconds: 20));

      expect(setup.actions.updateCalls, 0);
      expect(setup.actions.deleteCalls, 0);
    });

    testWidgets('édition de titre -> updateGroup appelé', (tester) async {
      final g = _group(name: 'Mon groupe', isPrivate: false);
      final setup = await _pumpBasic(
        tester,
        groupId: 'g1',
        groupDetailsStream: Stream.value(g),
      );

      final titleField = find.byType(TextField);
      expect(titleField, findsOneWidget);
      expect(find.text('Mon groupe'), findsOneWidget);

      await tester.enterText(titleField, 'Nouveau titre');
      await tester.pump();

      await tester.tap(find.widgetWithText(CustomElevatedButton, 'Modifier'));
      await tester.pump(const Duration(milliseconds: 20));

      expect(setup.actions.updateCalls, 1);
      expect(setup.actions.lastUpdatedGroup?.groupName, 'Nouveau titre');
      expect(setup.actions.lastUpdatedByUserId, 'me');
    });

    testWidgets('toggle prive (onChanged) passe isPrivate à true dans updateGroup', (tester) async {
      final g = _group(isPrivate: false);
      final setup = await _pumpBasic(
        tester,
        groupId: 'g1',
        groupDetailsStream: Stream.value(g),
      );

      // Le libellé est rendu
      expect(find.text('Groupe privé'), findsOneWidget);

      // Récupère le CustomAnimatedToggle et appelle onChanged(true)
      final toggleFinder = find.byType(CustomAnimatedToggle);
      expect(toggleFinder, findsOneWidget);
      final toggle = tester.widget<CustomAnimatedToggle>(toggleFinder);
      toggle.onChanged(true); // <-- déclenche la logique interne
      await tester.pump();

      // Sauvegarde
      await tester.tap(find.widgetWithText(CustomElevatedButton, 'Modifier'));
      await tester.pump(const Duration(milliseconds: 20));

      expect(setup.actions.updateCalls, 1);
      expect(setup.actions.lastUpdatedGroup?.isPrivate, isTrue); // <-- doit être TRUE
    });

    testWidgets('ouverture puis confirmation de suppression -> deleteGroup + navigation',
        (tester) async {
      final g = _group();
      final setup = await _pumpWithRouter(
        tester,
        groupId: 'g1',
        groupDetailsStream: Stream.value(g),
      );

      final deleteBtn = find.widgetWithText(CustomElevatedButton, 'Supprimer le groupe');
      expect(deleteBtn, findsOneWidget);
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      final dialog = find.byType(CustomConfirmationDialog);
      expect(dialog, findsOneWidget);

      final confirm = find.descendant(of: dialog, matching: find.text('Supprimer'));
      expect(confirm, findsOneWidget);
      await tester.tap(confirm);
      await tester.pumpAndSettle();

      expect(setup.actions.deleteCalls, 1);
      expect(setup.actions.lastDeletedGroupId ?? setup.actions.lastDeletedGroupId,
          anyOf(isNull, equals('g1')));

      expect(find.text('Groups page'), findsOneWidget);
    });

    testWidgets('annulation dans la boîte de dialogue ferme le dialog', (tester) async {
      final g = _group();
      await _pumpBasic(
        tester,
        groupId: 'g1',
        groupDetailsStream: Stream.value(g),
      );

      await tester.tap(find.widgetWithText(CustomElevatedButton, 'Supprimer le groupe'));
      await tester.pumpAndSettle();

      final dialog = find.byType(CustomConfirmationDialog);
      expect(dialog, findsOneWidget);

      final cancel = find.descendant(of: dialog, matching: find.textContaining('Annul'));
      if (cancel.evaluate().isNotEmpty) {
        await tester.tap(cancel);
      } else {
        // fallback si ton composant n’a pas de bouton "Annuler"
        await tester.tapAt(const Offset(5, 5));
      }
      await tester.pumpAndSettle();

      expect(dialog, findsNothing);
    });
  });
}
