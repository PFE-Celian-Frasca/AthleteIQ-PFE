import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String pseudo,
    @Default(
        "https://w7.pngwing.com/pngs/177/551/png-transparent-user-interface-design-computer-icons-default-stephen-salazar-graphy-user-interface-design-computer-wallpaper-sphere-thumbnail.png")
    String image,
    required String email,
    @Default([]) List<String> friends,
    @Default([]) List<String> sentFriendRequests,
    @Default([]) List<String> receivedFriendRequests,
    @Default([]) List<String> fav,
    required String sex,
    @Default(5.0) double objectif,
    required DateTime createdAt,
    @Default(0.0) double totalDist,
    String? fcmToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
