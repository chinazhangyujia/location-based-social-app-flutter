import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/comment_notification.dart';
import 'package:location_based_social_app/provider/notifications_provider.dart';
import 'package:provider/provider.dart';

class UnnotifiedCommentsScreen extends StatelessWidget {

  static const String router = '/UnnotifiedCommentsScreen';

  @override
  Widget build(BuildContext context) {
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);
    List<CommentNotification> commentNotifications = notificationsProvider.commentNotifications;

    if (commentNotifications.isNotEmpty) {
      notificationsProvider.markCommentNotificationsAsNotified(commentNotifications.map((e) => e.id).toList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        elevation: 0.5,
      ),
      body: ListView.builder(
          itemCount: commentNotifications.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8, bottom: 15, left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat("MMM dd, yyyy hh:mm").format(commentNotifications[index].time)),
                      SizedBox(height: 3,),
                      RichText(
                        maxLines: null,
                        text: TextSpan(
                            style: TextStyle(height: 1.3, fontSize: 17, color: Colors.black),
                            children: [
                              TextSpan(
                                text: '${commentNotifications[index].sendFrom.name} ',
                                style: TextStyle(fontWeight: FontWeight.w500)
                              ),
                              TextSpan(
                                text: commentNotifications[index].type == CommentType.COMMENT ? 'commented: ' : 'replied: ',
                                style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w500)
                              ),
                              TextSpan(
                                text: commentNotifications[index].content
                              )
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(indent: 10, height: 0,)
              ],
            ),
          )
      )
    );
  }
}
