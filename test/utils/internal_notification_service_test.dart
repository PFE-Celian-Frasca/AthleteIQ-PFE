import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('handleError throws formatted exception', () {
    expect(
      () => handleError('error', 'load'),
      throwsA(isA<Exception>()),
    );
  });
}
