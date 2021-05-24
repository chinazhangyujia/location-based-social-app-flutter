import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/user.dart';

/**
 * comment for a post
 */
class Comment {
  final String id;
  final User sendFrom;

  /**
   * null if it is a comment to the post
   */
  final User sendTo;

  final String content;
  final DateTime postTime;

  const Comment({
    @required this.id,
    @required this.sendFrom,
    this.sendTo,
    @required this.content,
    @required this.postTime
  });
}