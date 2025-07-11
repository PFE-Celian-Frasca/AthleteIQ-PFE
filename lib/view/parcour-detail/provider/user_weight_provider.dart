import 'package:hooks_riverpod/hooks_riverpod.dart';

final userWeightProvider = StateNotifierProvider<UserWeightNotifier, double>((ref) {
  return UserWeightNotifier();
});

class UserWeightNotifier extends StateNotifier<double> {
  UserWeightNotifier() : super(70.0);

  set userWeight(double weight) => state = weight;
}
