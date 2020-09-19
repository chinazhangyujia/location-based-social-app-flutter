import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/model/user.dart';

class UserNotification {
  String get avatarUrl {}

  String get message {}

  DateTime get happenedOn {}
}

class FollowStatusNotification implements UserNotification {
  final DateTime happenedOn;
  final User follower;
  final User followee;

  FollowStatusNotification({
    @required this.happenedOn,
    @required this.follower,
    @required this.followee
  });

  @override
  String get avatarUrl => follower.avatarUrl;

  @override
  String get message => '${follower.name} followed ${followee.name}';

}

class CommentNotification implements UserNotification {
  final DateTime happenedOn;
  final Post post;
  final User replier;

  CommentNotification({
    @required this.happenedOn,
    @required this.post,
    @required this.replier
  });

  @override
  String get avatarUrl => replier.avatarUrl;

  @override
  String get message => '${replier.name} replied you';
}