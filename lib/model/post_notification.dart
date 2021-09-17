import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/user.dart';

enum NotificationType {
  COMMENT,
  LIKE
}

/// When any other user like or comment on the current user's post
/// we want to show a red number on the corner of the bell icon on the top right.
/// This class represents a notification
class PostNotification {
  final String id;
  final User sendFrom;
  final String content;
  final NotificationType type;
  final String postId;
  final DateTime time;
  bool notified;

  PostNotification({
    @required this.id,
    @required this.sendFrom,
    @required this.content,
    @required this.type,
    @required this.postId,
    @required this.time,
    @required this.notified
  });
}