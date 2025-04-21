import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    String? id,
    required String admin,
    required String groupName,
    String? groupIcon,
    @Default([]) List<String> members,
    @Default('public') String type,
    @Default('') String? recentMessage,
    String? recentMessageSender,
    DateTime? recentMessageTime,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
}
