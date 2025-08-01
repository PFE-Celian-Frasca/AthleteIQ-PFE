import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/enums/enums.dart';

void main() {
  test('MessageEnumExtension converts string to enum', () {
    expect('text'.toMessageEnum(), MessageEnum.text);
    expect('image'.toMessageEnum(), MessageEnum.image);
    expect('video'.toMessageEnum(), MessageEnum.video);
    expect('unknown'.toMessageEnum(), MessageEnum.text);
  });
}
