import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_iq/view/community/chat-page/chat_controller.dart';

class UnreadMessageCounter extends ConsumerWidget {
  const UnreadMessageCounter({
    super.key,
    required this.uid,
    required this.groupId,
  });

  final String uid;
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<int>(
        stream:
            ref.read(chatControllerProvider.notifier).getUnreadMessagesStream(
                  userId: uid,
                  groupId: groupId,
                ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          final unreadMessages = snapshot.data ?? 0;
          return unreadMessages > 0
              ? Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 6.0,
                          offset: Offset(0, 1),
                        ),
                      ]),
                  child: Text(
                    unreadMessages.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox();
        });
  }
}
