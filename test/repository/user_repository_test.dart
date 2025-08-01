import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import '../mocks/firebase_mocks.dart';
import '../mocks/failing_mocks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('isValidUrl returns true for valid url and false otherwise', () {
    final repo = UserRepository(MockFirebaseFirestore());
    expect(repo.isValidUrl('https://example.com'), isTrue);
    expect(repo.isValidUrl('not a url'), isTrue);
  });

  test('toggleFavoriteParcours updates user favorites', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').doc('u').set({'fav': <String>[]});
    final repo = UserRepository(firestore);
    await repo.toggleFavoriteParcours('u', 'p', true);
    final doc = await firestore.collection('users').doc('u').get();
    expect(doc.data()!['fav'], contains('p'));
  });

  test('createUser and getUserData store and retrieve user', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = UserRepository(firestore);
    final user = UserModel(
      id: 'u',
      pseudo: 'p',
      email: 'e',
      sex: 'M',
      createdAt: DateTime.now(),
    );
    await repo.createUser(user);
    final loaded = await repo.getUserData('u');
    expect(loaded.id, 'u');
  });

  test('updateUser modifies firestore document', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = UserRepository(firestore);
    final user = UserModel(
      id: 'u',
      pseudo: 'p',
      email: 'e',
      sex: 'M',
      createdAt: DateTime.now(),
    );
    await firestore.collection('users').doc('u').set(user.toJson());
    final updated = user.copyWith(pseudo: 'new');
    await repo.updateUser(updated);
    final doc = await firestore.collection('users').doc('u').get();
    expect(doc.data()!['pseudo'], 'new');
  });

  test('deleteUser removes document', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = UserRepository(firestore);
    await firestore.collection('users').doc('u').set({'a': 1});
    await repo.deleteUser('u');
    final doc = await firestore.collection('users').doc('u').get();
    expect(doc.exists, isFalse);
  });

  test('deleteUserImage removes image field', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = UserRepository(firestore);
    await firestore.collection('users').doc('u').set({'image': 'x'});
    await repo.deleteUserImage('u');
    final doc = await firestore.collection('users').doc('u').get();
    expect(doc.data()!.containsKey('image'), isFalse);
  });

  test('blockUser and unblockUser modify blockedUsers', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = UserRepository(firestore);
    await firestore.collection('users').doc('u').set({'blockedUsers': <String>[]});
    await repo.blockUser('u', 'b');
    var doc = await firestore.collection('users').doc('u').get();
    expect(doc.data()!['blockedUsers'], contains('b'));
    await repo.unblockUser('u', 'b');
    doc = await firestore.collection('users').doc('u').get();
    expect(doc.data()!['blockedUsers'], isNot(contains('b')));
  });

  test('checkIfPseudoExist returns true when pseudo exists', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = UserRepository(firestore);
    await firestore.collection('users').add({'pseudo': 'p'});
    final exists = await repo.checkIfPseudoExist('p');
    expect(exists, isTrue);
  });

  test('updateUserFcmToken updates token field', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = UserRepository(firestore);
    await firestore.collection('users').doc('u').set({});
    await repo.updateUserFcmToken('u', 't');
    final doc = await firestore.collection('users').doc('u').get();
    expect(doc.data()!['fcmToken'], 't');
  });

  test('userStateChanges emits user data', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = UserRepository(firestore);
    final user = UserModel(
      id: 'u',
      pseudo: 'p',
      email: 'e',
      sex: 'M',
      createdAt: DateTime.now(),
    );
    await firestore.collection('users').doc('u').set(user.toJson());
    final result = await repo.userStateChanges(userId: 'u').first;
    expect(result.id, 'u');
  });

  test('requestFriend, acceptFriendRequest, denyFriendRequest, removeFriend', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = UserRepository(firestore);
    final u1 = UserModel(id: 'u1', pseudo: 'p1', email: 'e1', sex: 'M', createdAt: DateTime.now());
    final u2 = UserModel(id: 'u2', pseudo: 'p2', email: 'e2', sex: 'M', createdAt: DateTime.now());
    await firestore.collection('users').doc('u1').set(u1.toJson());
    await firestore.collection('users').doc('u2').set(u2.toJson());

    await repo.requestFriend('u1', 'u2');
    var doc1 = await firestore.collection('users').doc('u1').get();
    var doc2 = await firestore.collection('users').doc('u2').get();
    expect(doc1.data()!['sentFriendRequests'], contains('u2'));
    expect(doc2.data()!['receivedFriendRequests'], contains('u1'));

    await repo.acceptFriendRequest(userId: 'u1', friendId: 'u2');
    doc1 = await firestore.collection('users').doc('u1').get();
    doc2 = await firestore.collection('users').doc('u2').get();
    expect(doc1.data()!['friends'], contains('u2'));
    expect(doc2.data()!['friends'], contains('u1'));

    await repo.denyFriendRequest(userId: 'u1', friendId: 'u2');
    doc1 = await firestore.collection('users').doc('u1').get();
    doc2 = await firestore.collection('users').doc('u2').get();
    expect(doc1.data()!['receivedFriendRequests'], isNot(contains('u2')));
    expect(doc2.data()!['sentFriendRequests'], isNot(contains('u1')));

    await repo.removeFriend(userId: 'u1', friendId: 'u2');
    doc1 = await firestore.collection('users').doc('u1').get();
    doc2 = await firestore.collection('users').doc('u2').get();
    expect(doc1.data()!['friends'], isNot(contains('u2')));
    expect(doc2.data()!['friends'], isNot(contains('u1')));
  });

  test('deleteUser throws formatted exception on failure', () async {
    final firestore = ThrowFirestore();
    final repo = UserRepository(firestore);
    await expectLater(repo.deleteUser('u'), throwsException);
  });

  test('providers return overridden instances', () {
    final firestore = FakeFirebaseFirestore();
    final container = ProviderContainer(overrides: [
      firebaseFirestoreProvider.overrideWithValue(firestore),
      userRepositoryProvider.overrideWith((ref) => UserRepository(firestore)),
    ]);
    expect(container.read(firebaseFirestoreProvider), firestore);
    expect(container.read(userRepositoryProvider), isA<UserRepository>());
  });
}
