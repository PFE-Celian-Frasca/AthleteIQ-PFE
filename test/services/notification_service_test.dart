import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:athlete_iq/services/notification_service.dart';

void main() {
  test('markAsRead updates Firestore document', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('notifications').doc('id').set({'isRead': false});
    final service = NotificationService(firestore);
    final result = await service.markAsRead('id');
    final doc = await firestore.collection('notifications').doc('id').get();
    expect(result, isTrue);
    expect(doc.data()!['isRead'], isTrue);
  });

  test('fetchNotificationsForUser returns list', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('notifications').add({
      'userId': 'u',
      'id': 'n1',
      'title': 't',
      'body': 'b',
      'createdAt': DateTime.now().toIso8601String(),
    });
    final service = NotificationService(firestore);
    final result = await service.fetchNotificationsForUser('u');
    expect(result.length, 1);
  });
}
