import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/utils/get_user_info_provider.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockUserService extends Mock implements UserService {}

void main() {
  late ProviderContainer container;
  late MockUserService mockUserService;

  setUp(() {
    mockUserService = MockUserService();
    container = ProviderContainer(
      overrides: [userServiceProvider.overrideWithValue(mockUserService)],
    );
    addTearDown(container.dispose);
  });

  final user = UserModel(
    id: 'u1',
    pseudo: 'Alice',
    email: 'a@b.c',
    createdAt: DateTime(2024, 1, 1),
    sex: 'F',
  );

  test('getUserInfoProvider renvoie le UserModel depuis le service', () async {
    when(() => mockUserService.getUserData('u1')).thenAnswer((_) async => user);

    final result = await container.read(getUserInfoProvider('u1').future);

    expect(result, user);
    verify(() => mockUserService.getUserData('u1')).called(1);
  });

  test('getUserInfoProvider propage l\'erreur du service', () {
    when(() => mockUserService.getUserData('u1')).thenThrow(Exception('fail'));

    expect(container.read(getUserInfoProvider('u1').future), throwsA(isA<Exception>()));
  });
}
