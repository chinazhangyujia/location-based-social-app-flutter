import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:location_based_social_app/util/config.dart';

class UserAccessor {

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  static Future<Map> getUserById(String userId) async {
    String url = '${SERVICE_DOMAIN}/userById/$userId';

    final res = await http.get(url, headers: requestHeader);

    return json.decode(res.body);
  }
}