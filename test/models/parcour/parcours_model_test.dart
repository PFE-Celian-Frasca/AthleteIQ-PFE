import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/timer/custom_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Converters', () {
    test('DateTimeTimestampConverter fromJson', () {
      const converter = DateTimeTimestampConverter();
      final now = DateTime.now();
      final timestamp = Timestamp.fromDate(now);
      expect(converter.fromJson(timestamp), now);
      expect(converter.fromJson(now.toIso8601String()), now);
      expect(converter.toJson(now), now);
    });

    test('ParcourVisibilityConverter', () {
      const converter = ParcourVisibilityConverter();
      expect(converter.fromJson('public'), ParcourVisibility.public);
      expect(converter.toJson(ParcourVisibility.private), 'private');
    });

    test('SportTypeConverter', () {
      const converter = SportTypeConverter();
      expect(converter.fromJson('velo'), SportType.velo);
      expect(converter.toJson(SportType.marche), 'marche');
    });
  });

  test('ParcoursModel json round trip', () {
    final model = ParcoursModel(
      id: '1',
      owner: 'owner',
      title: 'title',
      type: ParcourVisibility.public,
      sportType: SportType.course,
      shareTo: const ['a', 'b'],
      timer: const CustomTimer(hours: 1, minutes: 2, seconds: 3),
      createdAt: DateTime(2024, 1, 1),
      vm: 0,
      totalDistance: 10,
      parcoursDataUrl: 'url',
    );
    final json = model.toJson();
    final fromJson = ParcoursModel.fromJson(json);
    expect(fromJson, model);
  });
}
