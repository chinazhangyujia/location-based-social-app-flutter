import 'package:flutter/material.dart';
import 'package:location_based_social_app/dummy_data/dummy_data.dart';
import 'package:location_based_social_app/model/notification.dart';
import 'package:location_based_social_app/widget/notification_item.dart';

class NotificationScreen extends StatelessWidget {

  final List<UserNotification> notifications = DUMMY_NOTIFICATION;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) => Column(
          children: [
            NotificationItem(
              notifications[index]
            ),
            Divider()
          ],
        )
      ),
    );
  }
}
