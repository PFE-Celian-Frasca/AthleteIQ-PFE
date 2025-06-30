import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>(
  (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0); // Démarre avec l'indice 0

  void setIndex(int index) {
    state = index;
  }
}
