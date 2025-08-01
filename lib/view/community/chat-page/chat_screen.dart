import 'package:athlete_iq/providers/groupe/group_details/group_details_provider.dart';
import 'package:athlete_iq/resources/components/custom_app_bar.dart';
import 'package:athlete_iq/utils/string_capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athlete_iq/view/community/chat-page/components/bottom_chat_field.dart';
import 'package:athlete_iq/view/community/chat-page/components/chat_list.dart';

class ChatScreen extends ConsumerWidget {
  final String groupId;

  const ChatScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupDetailsAsync = ref.watch(groupDetailsProvider(groupId));

    return groupDetailsAsync.when(
      data: (groupDetails) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            hasBackButton: true,
            backIcon: Icons.arrow_back,
            onBackButtonPressed: () => Navigator.of(context).pop(),
            title: groupDetails.groupName.capitalize(),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => GoRouter.of(context).go('/groups/chat/$groupId/details'),
              ),
            ],
          ),
          body: FocusTraversalGroup(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ChatList(
                      groupId: groupId,
                    ),
                  ),
                  BottomChatField(
                    groupId: groupId,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Text('Failed to load group details: $error'),
        ),
      ),
    );
  }
}
