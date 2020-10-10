import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/location_point.dart';
import 'package:location_based_social_app/model/user.dart';

class Post {
  final String id;
  final User user;
  final DateTime postedTimeStamp;
  final List<String> photoUrls;
  final String content;
  final LocationPoint postLocation;

  const Post({
    @required this.id,
    @required this.user,
    @required this.postedTimeStamp,
    @required this.photoUrls,
    @required this.content,
    @required this.postLocation
  });
}