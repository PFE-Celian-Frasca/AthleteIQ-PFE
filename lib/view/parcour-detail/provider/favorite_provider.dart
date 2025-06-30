import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/utils/internal_notification/internal_notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteNotifierProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, bool>>((ref) {
  return FavoriteNotifier(ref);
});

class FavoriteNotifier extends StateNotifier<Map<String, bool>> {
  final Ref ref;

  FavoriteNotifier(this.ref) : super({});

  void toggleFavorite(String userId, String parcourId, bool isFavorite) async {
    await ref
        .read(userRepositoryProvider)
        .toggleFavoriteParcours(userId, parcourId, !isFavorite);
    state = {...state, parcourId: !isFavorite};
    ref.read(internalNotificationProvider).showToast(!isFavorite
        ? "Parcours ajouté aux favoris"
        : "Parcours retiré des favoris");
  }
}
