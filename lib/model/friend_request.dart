import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/user.dart';

class FriendRequest {
  final String id;
  final User sendFrom;
  final String status;
  final bool notified;

  const FriendRequest({
    @required this.id,
    @required this.sendFrom,
    @required this.status,
    @required this.notified
  });
}