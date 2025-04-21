import 'dart:async';
import 'dart:io';
import 'package:athlete_iq/providers/groupe/group_actions/group_action_provider.dart';
import 'package:athlete_iq/services/group_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../group_chat_state.dart';

final groupChatProvider =
    StateNotifierProvider.family<GroupChatNotifier, GroupChatState, String>(
  (ref, groupId) => GroupChatNotifier(ref, groupId),
);

class GroupChatNotifier extends StateNotifier<GroupChatState> {
  final Ref _ref;
  final String _groupId;

  GroupChatNotifier(this._ref, this._groupId)
      : super(const GroupChatState.initial()) {
    loadGroupAndSubscribeToMessages();
  }

  Future<void> loadGroupAndSubscribeToMessages() async {
    state = const GroupChatState.loading();
    try {
      // Asynchronously fetch the group details
      final groupDetails =
          await _ref.read(groupService).getUserGroupById(_groupId);
      final messagesStream =
          _ref.read(groupService).getGroupMessagesStream(_groupId);
      state = GroupChatState.loaded(
        groupDetails: groupDetails,
        messagesStream: messagesStream,
        isSending: false,
      );
    } catch (e) {
      state = GroupChatState.error(e.toString());
    }
  }

  Future<void> sendMessage(
      String content, List<File> imageFiles, String userId) async {
    state.maybeWhen(
        loaded: (groupDetails, messagesStream, isSending) async {
          if (!isSending) {
            // Check if not already sending to avoid multiple sends
            state = GroupChatState.loaded(
              groupDetails: groupDetails,
              messagesStream: messagesStream,
              isSending: true,
            );
            try {
              await _ref
                  .read(groupService)
                  .sendMessageToGroup(_groupId, userId, content, imageFiles);
              state = GroupChatState.loaded(
                groupDetails: groupDetails,
                messagesStream: messagesStream,
                isSending: false,
              );
              final updatedGroup = groupDetails.copyWith(
                recentMessage: content,
                recentMessageTime: DateTime.now(),
              );
              await _ref
                  .read(groupActionsProvider.notifier)
                  .updateGroup(updatedGroup, userId);
            } catch (e) {
              state = GroupChatState.error(e.toString());
              state = GroupChatState.loaded(
                groupDetails: groupDetails,
                messagesStream: messagesStream,
                isSending: false,
              );
            }
          }
        },
        orElse: () {} // Handle other states if necessary
        );
  }
}
