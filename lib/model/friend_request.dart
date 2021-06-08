import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/user.dart';

/// Add friend request to the current user
class FriendRequest {
  final String id;
  final User sendFrom;
  final String status; // pending, denied, accepted
  final bool notified;

  const FriendRequest({
    @required this.id,
    @required this.sendFrom,
    @required this.status,
    @required this.notified
  });
}