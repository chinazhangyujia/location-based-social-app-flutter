import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/exception/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<void> signup(String email, String password, String name, String uniqueName, String birthday) async {
    String url = 'http://localhost:3000/user/signup';

    try {
      final res = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'name': name,
        'uniqueName': uniqueName,
        'birthday': birthday
      }), headers: requestHeader);

      if (res.statusCode != 200) {
        throw HttpException(json.decode(res.body)['message']);
      }

      print(json.decode(res.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    String url = 'http://localhost:3000/user/login';

    try {
      final res = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
      }), headers: requestHeader);

      print(json.decode(res.body));

      if (res.statusCode != 200) {
        throw HttpException('Failed to login in');
      }
    } catch(error) {
      throw HttpException('Failed to login in');
    }
  }

}