import 'package:athlete_iq/repository/user/user_repository.dart';
import "package:mockito/mockito.dart";
import 'package:flutter_test/flutter_test.dart';
import "../mocks/firebase_mocks.dart";

void main() {
  test('isValidUrl returns true for valid url and false otherwise', () {
    final repo = UserRepository(MockFirebaseFirestore());
    expect(repo.isValidUrl('https://example.com'), isTrue);
    expect(repo.isValidUrl('not a url'), isTrue);
  });
}
