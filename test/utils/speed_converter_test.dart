import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/utils/speed_converter.dart';

void main() {
  group('toKmH', () {
    test('converts m/s to km/h', () {
      expect(toKmH(speed: 0), 0);
      expect(toKmH(speed: 1), 3.6);
      expect(toKmH(speed: 10), 36);
    });
  });
}
