import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>(
  (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0); // Démarre avec l'indice 0

  set index(int index) => state = index;
}
