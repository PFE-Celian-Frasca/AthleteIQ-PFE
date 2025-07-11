import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/utils/get_user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClusterItemsDialog extends HookConsumerWidget {
  final Set<ParcoursWithGPSData> clusterItems;
  final void Function(ParcoursWithGPSData) onSelectParcour;

  const ClusterItemsDialog({
    super.key,
    required this.clusterItems,
    required this.onSelectParcour,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Liste des parcours',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.6, // Limite la hauteur à 60% de la hauteur de l'écran
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 10),
                    shrinkWrap: true,
                    itemCount: clusterItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = clusterItems.elementAt(index);
                      return FutureBuilder<UserModel>(
                        future: ref.read(getUserInfoProvider(item.parcours.owner).future),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData) {
                            return ListTile(
                              title: Text(item.parcours.title),
                              subtitle: Text(
                                  "Créé par : ${snapshot.data!.pseudo}"), // Utilisation du vrai nom de l'utilisateur
                              onTap: () {
                                Navigator.of(context).pop();
                                onSelectParcour(item);
                              },
                            );
                          } else {
                            return ListTile(
                              title: Text(item.parcours.title),
                              subtitle: const Text("Chargement..."),
                              onTap: () {},
                            );
                          }
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
