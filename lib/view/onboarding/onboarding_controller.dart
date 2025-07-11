import 'dart:async';

import 'package:athlete_iq/view/onboarding/provider/onboarding_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> completeOnboarding() async {
    final onboardingRepository = await ref.read(onboardingRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(onboardingRepository.setOnboardingComplete);
  }
}
