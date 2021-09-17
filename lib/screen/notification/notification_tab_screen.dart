import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/notifications_provider.dart';
import 'package:location_based_social_app/screen/notification/notification_screen.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:provider/provider.dart';

/// notification screen with tabs to switch between notification for comment or post
class NotificationTabScreen extends StatelessWidget {

  static const String router = '/NotificationTabScreen';

  @override
  Widget build(BuildContext context) {
    final NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context);

    final List<String> unnotifiedCommentNotifications = notificationsProvider.commentNotifications
      .where((element) => element.notified == false)
      .map((e) => e.id)
      .toList();

    final List<String> unnotifiedLikeNotifications = notificationsProvider.likeNotifications
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
          title: const Text(NotificationTabScreenConstant.TITLE),
          elevation: 0.5,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(NotificationTabScreenConstant.ALL, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(NotificationTabScreenConstant.COMMENT, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(NotificationTabScreenConstant.LIKES, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
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
