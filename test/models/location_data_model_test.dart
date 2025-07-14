import 'package:athlete_iq/models/parcour/location_data_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';

void main() {
  test('LocationDataModel json round trip', () {
    const model = LocationDataModel(latitude: 1, longitude: 2, altitude: 3);
    final json = model.toJson();
    final fromJson = LocationDataModel.fromJson(json);
    expect(fromJson, model);
  });

  test('locationDataToLocationDataModel converts list properly', () {
    final data = [
      LocationData.fromMap({'latitude': 1.0, 'longitude': 2.0}),
      LocationData.fromMap({'latitude': 3.0, 'longitude': 4.0})
    ];
    final models = locationDataToLocationDataModel(data);
    expect(models.length, 2);
    expect(models.first.latitude, 1.0);
    expect(models.last.longitude, 4.0);
  });
}
