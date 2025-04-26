import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:athlete_iq/view/info/components/parcour_tile_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavListScreen extends HookConsumerWidget {
  const FavListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      return const Center(child: Text("Utilisateur non connecté"));
    }

    final userId = currentUser.uid;
    final favoriteParcoursStream =
        ref.watch(userParcoursStreamProvider(userId));

    return Scaffold(
      body: favoriteParcoursStream.when(
        data: (parcoursLists) {
          final favoritesParcours = parcoursLists.isNotEmpty
              ? parcoursLists.last // Assuming the last list contains favorites
              : <ParcoursWithGPSData>[];
          return _buildListView(favoritesParcours, context, ref);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
    );
  }

  Widget _buildListView(List<ParcoursWithGPSData> parcoursList,
      BuildContext context, WidgetRef ref) {
    if (parcoursList.isEmpty) {
      return const Center(
          child: Text("Vous n'avez pas de parcours en favoris"));
    }
    return ListView.builder(
      itemCount: parcoursList.length,
      padding: EdgeInsets.only(bottom: 75.h, top: 10.h),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: parcourTile(parcoursList[index], context, ref),
        );
      },
    );
  }
}
