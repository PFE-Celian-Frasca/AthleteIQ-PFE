import 'dart:async';
import 'dart:io';
import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/message/message_model.dart';
import 'package:athlete_iq/models/message/last_message_model.dart';
import 'package:athlete_iq/repository/chat/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../mocks/firebase_mocks.dart';

class ThrowingFirestore extends Fake implements FirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    throw Exception('Firestore error');
  }
}

class FakeReference extends Fake implements Reference {
  FakeReference([this._fullPath]);

  /// Chemin du fichier ciblé (utile pour les expect)
  final String? _fullPath;

  bool deleted = false;

  @override
  Future<void> delete() async => deleted = true;

  @override
  String get fullPath => _fullPath ?? '';

  // Pas utilisé ici, mais requis par l’API.
  @override
  Reference child(String path) => FakeReference(path);
}

class FakeStorage extends Fake implements FirebaseStorage {
  String? lastPath;
  final FakeReference refInstance = FakeReference();

  @override
  Reference ref([String? path]) {
    lastPath = path;
    return refInstance;
  }
}

// ---------------------------------------------------------------------------
// FakeUploadTask : implémente juste Future.then()
// ---------------------------------------------------------------------------
class FakeUploadTask extends Fake implements UploadTask {
  FakeUploadTask(this._snapshot);
  final TaskSnapshot _snapshot;

  @override
  Future<R> then<R>(FutureOr<R> Function(TaskSnapshot) onValue,
      {Function? onError}) {
    try {
      return Future.value(onValue(_snapshot));
    } catch (e, s) {
      if (onError != null) return Future.error(e, s);
      rethrow;
    }
  }
}

// ---------------------------------------------------------------------------
// Repo dérivé : on capture l'appel à sendTextMessage sans toucher Firestore
// ---------------------------------------------------------------------------
class _TestChatRepository extends ChatRepository {
  _TestChatRepository(super.firestore, super.storage);

  MessageModel? lastSentMessage; // pour nos assertions

  @override
  Future<void> sendTextMessage({
    required MessageModel messageModel,
    required String groupId,
  }) async {
    lastSentMessage = messageModel; // on mémorise l'appel
  }
}

// ---------------------------------------------------------------------------
// Helpers de données de test
// ---------------------------------------------------------------------------

MessageModel _buildMessage({
  String id = 'msg_1',
  String sender = 'user_1',
  MessageEnum type = MessageEnum.text,
  String content = 'Hello',
  List<String> reactions = const [],
  List<String> isSeenBy = const [],
  List<String> deletedBy = const [],
}) =>
    MessageModel(
      senderUID: sender,
      senderName: 'Tester',
      senderImage: '',
      message: content,
      messageType: type,
      timeSent: DateTime.now(),
      messageId: id,
      isSeen: false,
      repliedMessage: '',
      repliedTo: '',
      repliedMessageType: MessageEnum.text,
      reactions: reactions,
      isSeenBy: isSeenBy,
      deletedBy: deletedBy,
    );

// ---------------------------------------------------------------------------
// Début des tests
// ---------------------------------------------------------------------------
@GenerateMocks([
  FirebaseFirestore,
  FirebaseStorage,
  Reference,
  UploadTask,
  TaskSnapshot,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatRepository – unité', () {
    late FakeFirebaseFirestore firestore;
    late FakeStorage storage;
    late ChatRepository repo;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      storage = FakeStorage();
      repo = ChatRepository(firestore, storage);
    });

    // ---------------------------------------------------------------------
    // sendTextMessage
    // ---------------------------------------------------------------------
    test('sendTextMessage persiste le message + met à jour lastMessage', () async {
      // arrange
      const groupId = 'group_1';
      final message = _buildMessage();

      // un groupe minimal
      await firestore.collection('groups').doc(groupId).set({
        'membersUIDs': ['user_1', 'user_2']
      });

      // act
      await repo.sendTextMessage(messageModel: message, groupId: groupId);

      // assert – doc message créé
      final storedMessage = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(message.messageId)
          .get();

      expect(storedMessage.exists, isTrue);
      expect(storedMessage.data()!['message'], equals('Hello'));

      // assert – champs du groupe mis à jour
      final groupSnapshot = await firestore.collection('groups').doc(groupId).get();
      final data = groupSnapshot.data()!;
      expect(data['lastMessage'], equals('Hello'));
      expect(data['senderUID'], equals('user_1'));
      expect(data['messageType'], equals(MessageEnum.text.name));
    });

    test('sendTextMessage relance une Exception quand Firestore échoue', () {
      // arrange – on injecte le Fake qui jette immédiatement
      final firestoreFail = ThrowingFirestore();
      final repoFail = ChatRepository(firestoreFail, storage);
      final message = _buildMessage();

      // act & assert
      expect(
        () => repoFail.sendTextMessage(messageModel: message, groupId: 'g'),
        throwsA(isA<Exception>()),
      );
    });

    // ---------------------------------------------------------------------
    // sendReactionToMessage : trois branches -> remove, update, add
    // ---------------------------------------------------------------------
    group('sendReactionToMessage', () {
      const groupId = 'group_react';
      const messageId = 'msg_react';

      setUp(() async {
        // groupe + message de base
        await firestore.collection('groups').doc(groupId).set({
          'membersUIDs': ["user_1", "user_2"]
        });
        final msg = _buildMessage(
          id: messageId,
          reactions: ['user_1=👍', 'user_2=❤️'],
        );
        await firestore
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .doc(messageId)
            .set(msg.toJson());
      });

      test('retire la réaction si reaction=""', () async {
        // act
        await repo.sendReactionToMessage(
          senderUID: 'user_1',
          groupId: groupId,
          messageId: messageId,
          reaction: '',
        );

        // assert
        final updated = await firestore
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .doc(messageId)
            .get();

        final List reactions = updated.data()!['reactions'] as List;
        expect(reactions, equals(['user_2=❤️']));
      });

      test('met à jour une réaction existante', () async {
        // act
        await repo.sendReactionToMessage(
          senderUID: 'user_1',
          groupId: groupId,
          messageId: messageId,
          reaction: '😂',
        );

        // assert
        final updated = await firestore
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .doc(messageId)
            .get();

        expect(updated.data()!['reactions'], contains('user_1=😂'));
      });

      test('ajoute une nouvelle réaction', () async {
        // act
        await repo.sendReactionToMessage(
          senderUID: 'user_3',
          groupId: groupId,
          messageId: messageId,
          reaction: '🔥',
        );

        // assert
        final updated = await firestore
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .doc(messageId)
            .get();

        expect(updated.data()!['reactions'], contains('user_3=🔥'));
      });
    });

    // ---------------------------------------------------------------------
    // setMessageStatus
    // ---------------------------------------------------------------------
    test('setMessageStatus ajoute l’UID si absent', () async {
      // arrange
      const groupId = 'group_seen';
      const messageId = 'msg_seen';
      await firestore.collection('groups').doc(groupId).set({
        'membersUIDs': ['user_1', 'user_2'],
      });
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .set(_buildMessage(id: messageId).toJson());

      // act
      await repo.setMessageStatus(
        currentUserId: 'user_1',
        groupId: groupId,
        messageId: messageId,
        isSeenByList: const [],
      );

      // assert
      final updated = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .get();

      expect(updated.data()!['isSeenBy'], contains('user_1'));
    });

    // ---------------------------------------------------------------------
    // deleteMessage (branche deleteForEveryone = true + suppression fichier)
    // ---------------------------------------------------------------------
    test('deleteMessage marque supprimé pour tout le monde + supprime le fichier', () async {
      // arrange
      const groupId = 'group_del';
      const messageId = 'msg_del';
      await firestore.collection('groups').doc(groupId).set({
        'membersUIDs': ['user_1', 'user_2'],
      });
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .set(_buildMessage(id: messageId).toJson());

      // act
      await repo.deleteMessage(
        currentUserId: 'user_1',
        groupId: groupId,
        messageId: messageId,
        messageType: MessageEnum.image.name,
        deleteForEveryone: true,
      );

      // assert – le champ deletedBy contient tous les membres
      final msg = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .get();

      expect(msg.data()!['deletedBy'], unorderedEquals(['user_1', 'user_2']));

      // assert – appel du delete sur Firebase Storage
      expect(storage.refInstance.deleted, isTrue);
      expect(storage.lastPath, 'chatFiles/${MessageEnum.image.name}/user_1/$groupId/$messageId');
    });

    // ---------------------------------------------------------------------
    // getChatsListStream & getUnreadMessagesStream
    // ---------------------------------------------------------------------
    test('getChatsListStream émet la liste des derniers messages', () async {
      // arrange
      const userId = 'me';
      await firestore.collection('users').doc(userId).collection('chats').doc('chat_1').set({
        'senderUID': 'me',
        'contactUID': 'u2',
        'contactName': 'Bob',
        'contactImage': '',
        'message': 'Yo',
        'messageType': MessageEnum.text.name,
        'timeSent': DateTime.now().toIso8601String(),
        'isSeen': false,
      });

      // act
      final result = await repo.getChatsListStream(userId).first;

      // assert
      expect(result, isA<List<LastMessageModel>>());
      expect(result.length, 1);
      expect(result.first.message, 'Yo');
    });

    test('getUnreadMessagesStream compte les messages non lus', () async {
      // arrange
      const groupId = 'group_unread';
      const userId = 'reader';
      await firestore.collection('groups').doc(groupId).set({
        'membersUIDs': [userId, 'other'],
      });

      final msg1 = _buildMessage(id: 'm1'); // non lu
      final msg2 = _buildMessage(id: 'm2', isSeenBy: ['reader']); // déjà vu par reader

      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc('m1')
          .set(msg1.toJson());

      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc('m2')
          .set(msg2.toJson());

      // act
      final unread = await repo.getUnreadMessagesStream(userId: userId, groupId: groupId).first;

      // assert
      expect(unread, 1); // seul m1 est compté
    });

    // ---------------------------------------------------------------------
    // deleteFileFromStorage (test d’origine, conservé & adapté)
    // ---------------------------------------------------------------------
    test('deleteFileFromStorage supprime le fichier et construit le bon chemin', () async {
      // arrange
      final fakeStorage = FakeStorage();
      final repoWithFakeStorage = ChatRepository(firestore, fakeStorage);

      // act
      await repoWithFakeStorage.deleteFileFromStorage(
        currentUserId: 'u',
        groupId: 'g',
        messageId: 'm',
        messageType: 'image',
      );

      // assert
      expect(fakeStorage.lastPath, 'chatFiles/image/u/g/m');
      expect(fakeStorage.refInstance.deleted, isTrue);
    });

    // ---------------------------------------------------------------------
    // sendFileMessage (succès)
    // ---------------------------------------------------------------------
    test('sendFileMessage upload le fichier puis appelle sendTextMessage avec l’URL', () async {
      // arrange ----------------------------------------------------------------
      final storageMock = MockFirebaseStorage();
      final refMock     = MockReference();
      final taskSnap    = MockTaskSnapshot();

      const fakeUrl = 'https://fakeurl.com/file.png';
      final dummyFile = File('dummy');                 // pas besoin qu’il existe

      // message de départ
      final message = _buildMessage(
        id: 'm123',
        type: MessageEnum.image,
        content: '', // sera remplacé
      );

      // chemin attendu (doit correspondre à celui généré par le repo)
      final expectedPath =
          'chatFiles/${message.messageType.name}/${message.senderUID}/${message.messageId}';

      // stubs Firebase Storage
      when(storageMock.ref(any)).thenReturn(refMock);
      when(taskSnap.ref).thenReturn(refMock);
      when(refMock.getDownloadURL()).thenAnswer((_) async => fakeUrl);

      // putFile → UploadTask terminé immédiatement
      final uploadTask = FakeUploadTask(taskSnap);
      when(refMock.putFile(dummyFile)).thenReturn(uploadTask);

      // on capture sendTextMessage
      final testRepo = _TestChatRepository(firestore, storageMock);

      // act --------------------------------------------------------------------
      await testRepo.sendFileMessage(
        messageModel: message,
        file: dummyFile,
        groupId: 'g1',
      );

      // assert -----------------------------------------------------------------
      verify(storageMock.ref(expectedPath)).called(1);       // bon chemin
      expect(testRepo.lastSentMessage, isNotNull);           // sendTextMessage appelé
      expect(testRepo.lastSentMessage!.message, fakeUrl);    // URL injectée
    });

    // ---------------------------------------------------------------------
    // getLastMessageStream : deux branches
    // ---------------------------------------------------------------------
    test('getLastMessageStream (branch groupId non vide) émet les groupes contenant l’user',
        () async {
      // arrange
      await firestore.collection('groups').doc('g_stream').set({
        'membersUIDs': ['user_a']
      });

      // act
      final snap = await repo.getLastMessageStream(userId: 'user_a', groupId: 'g_stream').first;

      // assert
      expect(snap.docs.length, 1);
    });

    test('getLastMessageStream (branch groupId vide) émet les chats de l’user', () async {
      // arrange
      await firestore
          .collection('users')
          .doc('user_b')
          .collection('chats')
          .doc('c1')
          .set({'dummy': true});

      // act
      final snap = await repo.getLastMessageStream(userId: 'user_b', groupId: '').first;

      // assert
      expect(snap.docs.length, 1);
    });

    // ---------------------------------------------------------------------
    // getMessagesStream : ordre desc. par timeSent
    // ---------------------------------------------------------------------
    test('getMessagesStream renvoie les messages triés par timeSent desc', () async {
      // arrange
      const groupId = 'g_msgs';
      await firestore.collection('groups').doc(groupId).set({});
      final older = _buildMessage(
        id: 'old',
        content: 'old',
        sender: 'u',
        type: MessageEnum.text,
      );
      final newer = _buildMessage(
        id: 'new',
        content: 'new',
        sender: 'u',
        type: MessageEnum.text,
      );
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc('old')
          .set(older.toJson());
      await Future.delayed(const Duration(milliseconds: 1)); // assure l’ordre
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc('new')
          .set(newer.toJson());

      // act
      final list = await repo.getMessagesStream(groupId: groupId).first;

      // assert
      expect(list.first.messageId, 'new'); // le plus récent d’abord
      expect(list.last.messageId, 'old');
    });

    // ---------------------------------------------------------------------
    // deleteAllMessagesForUser
    // ---------------------------------------------------------------------
    test('deleteAllMessagesForUser supprime tous les messages de l’UID', () async {
      // arrange
      await firestore.collection('groups').doc('g1').set({});
      await firestore.collection('groups').doc('g2').set({});

      Future<void> add(String g, String m, String uid) =>
          firestore.collection('groups').doc(g).collection('messages').doc(m).set(
                _buildMessage(id: m, sender: uid).toJson(),
              );

      await add('g1', 'm1', 'target');
      await add('g2', 'm2', 'target');
      await add('g1', 'm3', 'other'); // doit rester

      // act
      await repo.deleteAllMessagesForUser('target');

      // assert
      final remaining = await firestore.collectionGroup('messages').get();
      expect(remaining.docs.where((d) => d.data()['senderUID'] == 'target'),
          isEmpty); // tous supprimés
      expect(remaining.docs.length, 1); // 'm3' subsiste
    });
  });
}
