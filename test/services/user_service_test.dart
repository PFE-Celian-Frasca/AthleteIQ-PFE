import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/user_service.dart';

class FakeStorage extends Fake implements FirebaseStorage {}

void main() {
  test('checkPseudoExists returns true when user exists', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').add({'pseudo': 'pseudo'});
    final storage = FakeStorage();
    final service = UserService(firestore, storage);

    final exists = await service.checkPseudoExists('pseudo');
    expect(exists, isTrue);
  });
}
