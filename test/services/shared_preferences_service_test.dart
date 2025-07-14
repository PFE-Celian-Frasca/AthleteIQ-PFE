import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athlete_iq/services/shared_preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferencesService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = SharedPreferencesService();
  });

  test('setString and getString', () async {
    await service.setString('k', 'v');
    expect(await service.getString('k'), 'v');
  });

  test('setBool and getBool', () async {
    await service.setBool('b', true);
    expect(await service.getBool('b'), true);
  });
}
