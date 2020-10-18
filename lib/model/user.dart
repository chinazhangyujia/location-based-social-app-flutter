import 'package:flutter/foundation.dart';

enum Gender {
  MALE,
  FEMALE
}

class User {
  final String id;
  final String name;
  final String avatarUrl;
  final DateTime birthday;
  final Gender gender;
  final String introduction;
  final Map<String, dynamic> metaData;

  const User({
    @required this.id,
    @required this.name,
    @required this.avatarUrl,
    @required this.birthday,
    @required this.gender,
    this.introduction,
    this.metaData = const {}
  });
}