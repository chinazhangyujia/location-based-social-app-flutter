import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:http/http.dart' as http;

class FriendsProvider with ChangeNotifier {
  List<User> _friends = [];

  String _token;

  void update(String token) {
    _token = token;
  }

  List<User> get friends {
    return [..._friends];
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };



}