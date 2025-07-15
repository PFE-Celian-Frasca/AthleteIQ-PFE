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

  test('other setters and getters', () async {
    await service.setInt('i', 1);
    expect(await service.getInt('i'), 1);

    await service.setDouble('d', 1.5);
    expect(await service.getDouble('d'), 1.5);

    await service.setStringList('l', ['a']);
    expect(await service.getStringList('l'), ['a']);

    await service.setObject('o', {'a': 1});
    final obj = await service.getObject('o', (Map<String, dynamic> j) => j);
    expect(obj, {'a': 1});

    await service.remove('o');
    expect(await service.getString('o'), isNull);

    await service.clear();
    expect(await service.getString('k'), isNull);
  });
}
