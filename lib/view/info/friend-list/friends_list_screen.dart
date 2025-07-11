import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/repository/user/user_repository.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:athlete_iq/view/info/components/user_tile_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendsListScreen extends HookConsumerWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text("Aucun utilisateur connecté"),
        ),
      );
    }

    final userId = currentUser.uid;
    final userStream = ref.watch(userStateChangesProvider(userId));

    return userStream.when(
      data: (user) {
        if (user == null) {
          return const Center(
            child: Text("Utilisateur non trouvé"),
          );
        }
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await ref.read(userRepositoryProvider).getUserData(userId);
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 90.h, top: 10.h),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: _buildSlivers(context, ref, user),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erreur: $error')),
    );
  }

  List<Widget> _buildSlivers(BuildContext context, WidgetRef ref, UserModel user) {
    final receivedFriendRequestsEmpty = user.receivedFriendRequests.isEmpty;
    final friendsEmpty = user.friends.isEmpty;

    if (receivedFriendRequestsEmpty && friendsEmpty) {
      return [
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(
              child: Text(
                "Aucune demande d'amis ou amis actuellement.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ];
    }

    return [
      if (!receivedFriendRequestsEmpty)
        _buildSection(context, ref, user.receivedFriendRequests, "Demandes d'amis", true),
      if (!friendsEmpty) _buildSection(context, ref, user.friends, "Amis", false),
    ];
  }

  Widget _buildSection(
      BuildContext context, WidgetRef ref, List<String> userIds, String title, bool friendRequest) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          FutureBuilder<List<UserModel>>(
            future: Future.wait(userIds.map((id) => ref.read(userServiceProvider).getUserData(id))),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Une erreur est survenue: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  children: snapshot.data!
                      .map((user) => userTile(user, context, ref, friendRequest))
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
