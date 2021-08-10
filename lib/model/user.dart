import 'package:flutter/foundation.dart';

/// represent one user
class User {
  final String id;
  final String name;
  final String avatarUrl;
  final String introduction;
  /// used to store some data that should not belong to the user table
  /// e.g. friendStatus: the friendship between this user and logged in user NOT_FRIEND | FRIEND | PENDING ...
  final Map<String, dynamic> metaData;

  const User({
    @required this.id,
    @required this.name,
    @required this.avatarUrl,
    this.introduction,
    this.metaData = const {}
  });
}