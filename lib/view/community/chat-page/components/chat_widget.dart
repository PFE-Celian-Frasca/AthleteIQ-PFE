import 'package:athlete_iq/enums/enums.dart';
import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/repository/auth/auth_repository.dart';
import 'package:athlete_iq/utils/string_capitalize.dart';
import 'package:athlete_iq/view/community/chat-page/components/unread_message_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatWidget extends ConsumerWidget {
  const ChatWidget({
    super.key,
    required this.group,
    required this.onTap,
  });

  final GroupModel group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(authRepositoryProvider).currentUser!.uid;

    // Extracting group details
    final lastMessage = group.lastMessage;
    final senderUID = group.senderUID;
    final timeSent = group.timeSent;
    final dateTime =
        DateFormat.Hm('fr_FR').format(timeSent); // Format time in French
    final imageUrl = group.groupImage;
    final name = group.groupName;
    final messageType = group.messageType;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          onBackgroundImageError: imageUrl.isNotEmpty ? (_, __) {} : null,
          child: imageUrl.isEmpty
              ? Text(
                  name.initials().toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        tileColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            if (uid == senderUID)
              const Text(
                'Vous:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (uid == senderUID) const SizedBox(width: 5),
            _buildMessagePreview(messageType, lastMessage),
          ],
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dateTime),
              UnreadMessageCounter(
                uid: uid,
                groupId: group.groupId,
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMessagePreview(MessageEnum messageType, String message) {
    switch (messageType) {
      case MessageEnum.text:
        return Flexible(
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
          ),
        );
      case MessageEnum.image:
        return const Row(
          children: [
            Icon(Icons.photo, size: 16),
            SizedBox(width: 5),
            Text(
              'Photo',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      case MessageEnum.video:
        return const Row(
          children: [
            Icon(Icons.videocam, size: 16),
            SizedBox(width: 5),
            Text(
              'Vidéo',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      case MessageEnum.audio:
        return const Row(
          children: [
            Icon(Icons.audiotrack, size: 16),
            SizedBox(width: 5),
            Text(
              'Audio',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      default:
        return const Text(
          '[Message]',
          overflow: TextOverflow.ellipsis,
        );
    }
  }
}
