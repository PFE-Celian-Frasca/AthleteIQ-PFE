import 'package:athlete_iq/view/parcour-detail/provider/user_weight_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('userWeightProvider default value', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(userWeightProvider), 70.0);
  });

  test('userWeightProvider can be updated', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(userWeightProvider.notifier);
    notifier.userWeight = 80.0;
    expect(container.read(userWeightProvider), 80.0);
  });
}
