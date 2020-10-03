import 'dart:convert';

import 'package:location_based_social_app/model/user.dart';

import 'package:http/http.dart' as http;

class UserAccessor {

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  static Future<Map> getUserById(String userId) async {
    String url = 'http://localhost:3000/userById/$userId';

    final res = await http.get(url, headers: requestHeader);

    return json.decode(res.body);
  }
}