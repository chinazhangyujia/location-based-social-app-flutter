import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/user.dart';

enum CommentType {
  COMMENT,
  REPLY
}

class CommentNotification {
  final String id;
  final User sendFrom;
  final String content;
  final CommentType type;
  final DateTime time;

  const CommentNotification({
    @required this.id,
    @required this.sendFrom,
    @required this.content,
    @required this.type,
    @required this.time
  });
}