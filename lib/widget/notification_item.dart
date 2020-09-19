import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/notification.dart';

class NotificationItem extends StatelessWidget {
  final UserNotification notification;

  NotificationItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(notification.avatarUrl),
      ),
      title: Text(notification.message),
      subtitle: Text(DateFormat("MMM dd, yyyy hh:mm").format(notification.happenedOn)),
      trailing: IconButton(
        icon: Icon(Icons.navigate_next),
        onPressed: () {},
      ),
    );
  }
}
