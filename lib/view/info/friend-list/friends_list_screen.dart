import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/view/info/components/userTileComponent.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendsListScreen extends ConsumerWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(globalProvider).userState;

    return Scaffold(
      body: userState.when(
        initial: () => const SizedBox(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message) => Center(child: Text('Error: $message')),
        loaded: (user) => RefreshIndicator(
          onRefresh: () async {
            await ref.read(globalProvider.notifier).loadUserProfile(user.id);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildSection(context, ref, user.receivedFriendRequests,
                  "Demandes d'amis", true),
              _buildSection(context, ref, user.friends, "Amis", false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, WidgetRef ref,
      List<String> userIds, String title, bool friendRequest) {
    if (userIds.isEmpty) {
      String emptyText = friendRequest
          ? "Aucune demande d'amis."
          : "Vous n'avez pas encore d'amis.";
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            emptyText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          FutureBuilder<List<UserModel>>(
            future: Future.wait(userIds
                .map((id) => ref.read(userServiceProvider).getUserData(id))),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Une erreur est survenue: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  children: snapshot.data!
                      .map(
                          (user) => userTile(user, context, ref, friendRequest))
                      .toList(),
                );
              } else {
                return const Text('Aucune donnée disponible.');
              }
            },
          ),
        ],
      ),
    );
  }
}
