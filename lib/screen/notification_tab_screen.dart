import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/notifications_provider.dart';
import 'package:location_based_social_app/screen/notification_screen.dart';
import 'package:provider/provider.dart';

class NotificationTabScreen extends StatelessWidget {

  static const String router = '/NotificationTabScreen';

  @override
  Widget build(BuildContext context) {
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context);

    List<String> unnotifiedCommentNotifications = notificationsProvider.commentNotifications
      .where((element) => element.notified == false)
      .map((e) => e.id)
      .toList();

    List<String> unnotifiedLikeNotifications = notificationsProvider.likeNotifications
      .where((element) => element.notified == false)
      .map((e) => e.id)
      .toList();

    notificationsProvider.markNotificationsAsNotified(
      unnotifiedCommentNotifications,
      unnotifiedLikeNotifications
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notification'),
          elevation: 0.5,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('All', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Comment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Likes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  )
                ]
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            NotificationScreen(notificationsProvider.allNotifications),
            NotificationScreen(notificationsProvider.commentNotifications),
            NotificationScreen(notificationsProvider.likeNotifications),
          ],
        )
      ),
    );
  }
}
