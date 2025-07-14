import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import "../mocks/firebase_mocks.dart";

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
}
