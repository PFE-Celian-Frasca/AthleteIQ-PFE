// test/view/community/update_group_screen_test.dart
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
import 'package:athlete_iq/view/community/chat-page/components/update_group_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

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
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ---- FAKE notifier basé sur ton vrai constructeur GroupActionsNotifier(Ref) ----
class _FakeGroupActionsNotifier extends GroupActionsNotifier {
  _FakeGroupActionsNotifier(this._ref) : super(_ref) {
    // Sécurise l'état initial au cas où.
    state = const GroupState.initial();
  }
  final Ref _ref;

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

/// Monte l’écran avec les overrides. On renvoie l’instance du fake notifier
/// pour pouvoir assert après coup.
Future<({
_FakeGroupActionsNotifier actions,
})> _pumpWithOverrides(
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

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // Auth (uid = 'me')
        authRepositoryProvider.overrideWithValue(_FakeAuthRepo()),

        // currentUserProvider('me') => Future<UserModel>
        currentUserProvider('me').overrideWith((ref) async => currentUser),

        // groupDetailsProvider(groupId) => Stream<GroupModel>
        groupDetailsProvider(groupId).overrideWith((ref) => groupDetailsStream),

        // Actions groupe => crée le fake avec le Ref requis, et capture l'instance
        groupActionsProvider.overrideWith((ref) {
          actions = _FakeGroupActionsNotifier(ref);
          return actions;
        }),

        // UserService utilisé pour charger les users si privé
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

// ---------------- Tests ----------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UpdateGroupScreen (GroupState)', () {
    testWidgets('affiche un loader tant que groupDetails n’a pas émis', (tester) async {
      final ctrl = StreamController<GroupModel>(); // aucun event -> loading
      await _pumpWithOverrides(
        tester,
        groupId: 'g1',
        groupDetailsStream: ctrl.stream,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await ctrl.close();
    });

    testWidgets('pré-remplit le titre, modifie puis appelle updateGroup', (tester) async {
      final g = _group(name: 'Mon groupe', isPrivate: false);
      final setup = await _pumpWithOverrides(
        tester,
        groupId: 'g1',
        groupDetailsStream: Stream.value(g),
      );

      // Titre prérempli
      final titleField = find.byType(TextField);
      expect(titleField, findsOneWidget);
      expect(find.text('Mon groupe'), findsOneWidget);

      // Saisie
      await tester.enterText(titleField, 'Nouveau titre');
      await tester.pump();

      // Bouton "Modifier"
      final editBtn = find.text('Modifier');
      expect(editBtn, findsOneWidget);
      await tester.tap(editBtn);

      // Laisse le faux "loading" se terminer
      await tester.pump(const Duration(milliseconds: 20));

      // Assertions
      expect(setup.actions.updateCalls, 1);
      expect(setup.actions.lastUpdatedByUserId, 'me');
      expect(setup.actions.lastUpdatedGroup?.groupId, 'g1');
      expect(setup.actions.lastUpdatedGroup?.groupName, 'Nouveau titre');
      expect(setup.actions.lastUpdatedGroup?.isPrivate, false);
    });

    testWidgets('ouvre la boite de dialogue de suppression', (tester) async {
      final g = _group();
      await _pumpWithOverrides(
        tester,
        groupId: 'g1',
        groupDetailsStream: Stream.value(g),
      );

      // -> cible le CustomElevatedButton qui porte ce texte
      final deleteBtn = find.widgetWithText(CustomElevatedButton, 'Supprimer le groupe');
      expect(deleteBtn, findsOneWidget);

      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      // Vérifie la présence de la boîte de dialogue custom
      final dialog = find.byType(CustomConfirmationDialog);
      expect(dialog, findsOneWidget);

      // Vérifie les textes à l'intérieur DU dialogue (et pas dans la page)
      expect(
        find.descendant(of: dialog, matching: find.text('Supprimer le groupe')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: dialog,
          matching: find.text('Êtes-vous sûr de vouloir supprimer ce groupe?'),
        ),
        findsOneWidget,
      );
    });
  });
}
