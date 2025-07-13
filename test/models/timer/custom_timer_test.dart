import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';

void main() {
  group('CustomTimerConverter', () {
    const converter = CustomTimerConverter();

    test('fromJson and toJson work correctly', () {
      final json = {'hours': 1, 'minutes': 2, 'seconds': 3};
      final timer = converter.fromJson(json);
      expect(timer.hours, 1);
      expect(timer.minutes, 2);
      expect(timer.seconds, 3);
      expect(converter.toJson(timer), json);
    });
  });
}
