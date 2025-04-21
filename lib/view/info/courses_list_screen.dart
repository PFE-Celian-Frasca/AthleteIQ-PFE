import 'package:athlete_iq/view/info/provider/all_parcours_list/combined_parcours_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import '../../view/info/components/parcourTileComponent.dart';

class CoursesListScreen extends HookConsumerWidget {
  const CoursesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcoursState = ref.watch(combinedParcoursProvider);
    return RefreshIndicator(
      onRefresh: () => ref.read(combinedParcoursProvider.notifier).getList(),
      child: parcoursState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : parcoursState.error != null
              ? Center(child: Text('Error: ${parcoursState.error}'))
              : _buildListView(parcoursState.loadedParcours ?? [], ref),
    );
  }

  Widget _buildListView(List<ParcoursWithGPSData> parcoursList, WidgetRef ref) {
    if (parcoursList.isEmpty) {
      return const Center(child: Text("Vous n'avez pas de parcours"));
    }
    return ListView.builder(
      itemCount: parcoursList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: parcourTile(parcoursList[index], context, ref),
        );
      },
    );
  }
}
