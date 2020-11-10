import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String avatarUrl;
  final DateTime birthday;
  final String introduction;
  final Map<String, dynamic> metaData;

  const User({
    @required this.id,
    @required this.name,
    @required this.avatarUrl,
    @required this.birthday,
    this.introduction,
    this.metaData = const {}
  });
}