import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String body,
    @Default(false) bool isRead,
    required DateTime createdAt,
    DateTime? readAt,
    // Vous pouvez ajouter d'autres champs spécifiques au type de notification.
    String?
        relatedContentId, // Utilisé pour des notifications liées à un contenu spécifique
    @Default('generic')
    String
        type, // Permet de catégoriser les notifications ('generic', 'friendRequest', 'message', etc.)
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
