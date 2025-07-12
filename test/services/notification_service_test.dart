import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:athlete_iq/services/notification_service.dart';

class FakeDoc extends Fake implements DocumentReference<Map<String, dynamic>> {
  bool updateCalled = false;
  @override
  Future<void> update(Map<Object?, Object?> data) async {
    updateCalled = true;
  }
}

class FakeCollection extends Fake implements CollectionReference<Map<String, dynamic>> {
  final FakeDoc docRef = FakeDoc();
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) => docRef;
}

class FakeFirestore extends Fake implements FirebaseFirestore {
  final FakeCollection collectionRef = FakeCollection();
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) => collectionRef;
}

void main() {
  test('markAsRead updates Firestore document', () async {
    final firestore = FakeFirestore();
    final service = NotificationService(firestore);
    final result = await service.markAsRead('id');
    expect(result, isTrue);
    expect(firestore.collectionRef.docRef.updateCalled, isTrue);
  });
}
