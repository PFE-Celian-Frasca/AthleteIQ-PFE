import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/utils/string_capitalize.dart';

void main() {
  group('StringExtension', () {
    test('capitalize returns empty when string is empty', () {
      expect(''.capitalize(), '');
    });

    test('capitalize capitalizes the first letter', () {
      expect('hello'.capitalize(), 'Hello');
    });

    test('initials returns first letters of words', () {
      expect('John Doe'.initials(), 'JD');
    });

    test('initials takes only first two words', () {
      expect('John Ronald Reuel'.initials(), 'JR');
    });
  });
}
