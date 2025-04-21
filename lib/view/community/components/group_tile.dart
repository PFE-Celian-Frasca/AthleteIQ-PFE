import 'package:athlete_iq/models/group/group_model.dart';
import 'package:athlete_iq/utils/stringCapitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Widget groupTile(GroupModel group, BuildContext context, WidgetRef ref) {
  bool isUnread = true;
  return InkWell(
    onTap: () {
      GoRouter.of(context).go("/groups/chat/${group.id}");
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Container(
            padding: EdgeInsets.all(2.w), // Added padding for the border
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
              border: isUnread
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.w,
                    )
                  : null,
            ),
            child: group.groupIcon != null && group.groupIcon!.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(group.groupIcon!),
                    radius: 25.r,
                  )
                : CircleAvatar(
                    radius: 25.r,
                    child: Text(group.groupName.initials()),
                  ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          group.groupName,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          height: 10.r,
                          width: 10.r,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    group.recentMessage!.length > 30
                        ? '${group.recentMessage!.substring(0, 25)}...'
                        : group.recentMessage!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(
              "${group.recentMessageTime?.hour.toString().padLeft(2, '0')}h${group.recentMessageTime?.minute.toString().padLeft(2, '0')}",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),
          ),
        ],
      ),
    ),
  );
}
