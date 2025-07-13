import 'package:athlete_iq/repository/chat/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/firebase_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FakeReference extends Fake implements Reference {
  bool deleted = false;
  @override
  Future<void> delete() async {
    deleted = true;
  }
}

class FakeStorage extends Fake implements FirebaseStorage {
  String? path;
  final FakeReference refInstance = FakeReference();
  @override
  Reference ref([String? path]) {
    this.path = path;
    return refInstance;
  }
}

void main() {
  test('deleteFileFromStorage calls FirebaseStorage.delete', () async {
    final firestore = MockFirebaseFirestore();
    final storage = FakeStorage();

    final repo = ChatRepository(firestore, storage);
    await repo.deleteFileFromStorage(
      currentUserId: 'u',
      groupId: 'g',
      messageId: 'm',
      messageType: 'image',
    );

    expect(storage.path, 'chatFiles/image/u/g/m');
    expect(storage.refInstance.deleted, isTrue);
  });
}
