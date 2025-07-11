import 'package:athlete_iq/models/group/group_model.dart';
import "package:mockito/mockito.dart";
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/group/group_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/firebase_mocks.dart';

class TestGroupRepository extends GroupRepository {
  TestGroupRepository(super.firestore);
  GroupModel? updated;
  @override
  Future<void> updateGroupDataInFireStore(GroupModel groupModel) async {
    updated = groupModel;
  }
}

void main() {
  test('addMemberToGroup adds member id', () async {
    final repo = TestGroupRepository(MockFirebaseFirestore());
    final group = GroupModel.empty();
    final user = UserModel(
      id: 'u1',
      pseudo: 'p',
      email: 'e',
      sex: 'M',
      createdAt: DateTime.now(),
    );

    await repo.addMemberToGroup(groupMember: user, groupModel: group);
    expect(repo.updated!.membersUIDs.contains('u1'), isTrue);
  });
}
