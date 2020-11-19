import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/user.dart';

enum NotificationType {
  COMMENT,
  LIKE
}

class PostNotification {
  final String id;
  final User sendFrom;
  final String content;
  final NotificationType type;
  final DateTime time;
  bool notified;

  PostNotification({
    @required this.id,
    @required this.sendFrom,
    @required this.content,
    @required this.type,
    @required this.time,
    @required this.notified
  });
}