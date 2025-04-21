import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/view/info/components/parcourTileComponent.dart';
import 'package:athlete_iq/view/info/provider/all_parcours_list/combined_parcours_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavListScreen extends HookConsumerWidget {
  const FavListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcoursState = ref.watch(combinedParcoursProvider);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(combinedParcoursProvider.notifier).getFavorites(),
        child: parcoursState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : parcoursState.error != null
                ? Center(child: Text('Error: ${parcoursState.error}'))
                : _buildListView(
                    parcoursState.favoritesParcours ?? [], context, ref),
      ),
    );
  }

  Widget _buildListView(List<ParcoursWithGPSData> parcoursList,
      BuildContext context, WidgetRef ref) {
    if (parcoursList.isEmpty) {
      return const Center(child: Text("Vous n'avez pas de parcours en favoris"));
    }
    return ListView.builder(
      itemCount: parcoursList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: parcourTile(parcoursList[index], context, ref),
        );
      },
    );
  }
}
