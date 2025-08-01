import 'package:athlete_iq/repository/parcour/parcours_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/view/info/components/parcour_tile_component.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';

class CoursesListScreen extends HookConsumerWidget {
  const CoursesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    if (userId == null) {
      return const Center(child: Text("Utilisateur non connecté"));
    }

    final parcoursStream = ref.watch(userParcoursStreamProvider(userId));

    return Scaffold(
      body: FocusTraversalGroup(
        child: parcoursStream.when(
          data: (parcoursLists) {
            for (var i = 0; i < parcoursLists.length; i++) {
              debugPrint('List $i: ${parcoursLists[i].map((p) => p.parcours.id).toList()}');
            }

            // Exclure la dernière liste et agréger les parcours restants
            final allParcours = parcoursLists.length > 1
                ? parcoursLists.sublist(0, parcoursLists.length - 1).expand((list) => list).toList()
                : <ParcoursWithGPSData>[];

            return _buildListView(allParcours, ref);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Erreur: $error')),
        ),
      ),
    );
  }

  Widget _buildListView(List<ParcoursWithGPSData> parcoursList, WidgetRef ref) {
    if (parcoursList.isEmpty) {
      return const Center(child: Text("Vous n'avez pas de parcours"));
    }
    return FocusTraversalGroup(
      child: ListView.builder(
        itemCount: parcoursList.length,
        padding: EdgeInsets.only(bottom: 75.h, top: 10.h),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: parcourTile(parcoursList[index], context, ref),
          );
        },
      ),
    );
  }
}
