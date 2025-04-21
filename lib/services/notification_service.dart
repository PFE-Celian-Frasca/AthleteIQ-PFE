import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/notification_model.dart';

final notificationService = Provider<NotificationService>((ref) {
  return NotificationService(FirebaseFirestore.instance);
});

class NotificationService {
  final FirebaseFirestore _firestore;

  NotificationService(this._firestore);

  Future<List<NotificationModel>> fetchNotificationsForUser(
      String userId) async {
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) =>
            NotificationModel.fromJson(doc.data()))
        .toList();
  }

  Future<bool> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
      'readAt': Timestamp.now(),
    });
    return true;
  }
}
