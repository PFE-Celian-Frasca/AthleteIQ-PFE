import 'package:athlete_iq/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final UserModel sender;
  final DateTime date;
  final bool sentByMe;
  final List<String>? images;

  const MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.date,
    required this.sentByMe,
    this.images,
  });

  @override
  Widget build(BuildContext context) {
    // Formatting the date
    String formattedDate = DateFormat('hh:mm a').format(date);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment:
            sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!sentByMe) // Show the sender's avatar if the message is not sent by me
                CircleAvatar(
                  backgroundImage: NetworkImage(sender.image),
                  radius: 16.r,
                ),
              SizedBox(width: 10.w),
              Expanded(
                child: Stack(
                  alignment:
                      sentByMe ? Alignment.bottomRight : Alignment.bottomLeft,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 14.w),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: sentByMe ? Colors.blue[300] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.isNotEmpty)
                            Text(
                              message,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          if (images != null && images!.isNotEmpty)
                            Column(
                              children: images!
                                  .map((imgUrl) => Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Image.network(
                                          imgUrl,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Align(
            alignment: sentByMe ? Alignment.bottomRight : Alignment.bottomLeft,
            child: Text(
              formattedDate,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
