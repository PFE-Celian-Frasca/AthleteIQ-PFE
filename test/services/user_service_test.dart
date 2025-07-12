import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:athlete_iq/services/user_service.dart';

class FakeQuerySnapshot extends Fake implements QuerySnapshot<Map<String, dynamic>> {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _docs;
  FakeQuerySnapshot(this._docs);
  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => _docs;
}

class FakeQuery extends Fake implements Query<Map<String, dynamic>> {
  final FakeQuerySnapshot snapshot;
  FakeQuery(this.snapshot);
  @override
  Query<Map<String, dynamic>> limit(int limit) => this;
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) async => snapshot;
}

class FakeCollection extends Fake implements CollectionReference<Map<String, dynamic>> {
  final FakeQuery query;
  FakeCollection(this.query);
  @override
  Query<Map<String, dynamic>> where(Object field,
      {Object? isEqualTo,
      Object? isNotEqualTo,
      Object? isLessThan,
      Object? isLessThanOrEqualTo,
      Object? isGreaterThan,
      Object? isGreaterThanOrEqualTo,
      Object? arrayContains,
      Iterable<Object?>? arrayContainsAny,
      Iterable<Object?>? whereIn,
      Iterable<Object?>? whereNotIn,
      bool? isNull}) =>
      query;
}

class FakeFirestore extends Fake implements FirebaseFirestore {
  final FakeCollection collectionRef;
  FakeFirestore(this.collectionRef);
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) => collectionRef;
}

class FakeStorage extends Fake implements FirebaseStorage {}

class FakeDoc extends Fake implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  test('checkPseudoExists returns true when user exists', () async {
    final querySnapshot = FakeQuerySnapshot([FakeDoc()]);
    final query = FakeQuery(querySnapshot);
    final firestore = FakeFirestore(FakeCollection(query));
    final storage = FakeStorage();
    final service = UserService(firestore, storage);

    final exists = await service.checkPseudoExists('pseudo');
    expect(exists, isTrue);
  });
}
