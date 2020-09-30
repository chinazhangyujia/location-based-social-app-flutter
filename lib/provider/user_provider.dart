import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/exception/http_exception.dart';

class UserProvider with ChangeNotifier {
  String _nickname;
  String _uniqueName;
  DateTime _birthday;
  String _email;

  String _token;

  void update(String token) {
    _token = token;
  }

  String get uniqueName {
    return _uniqueName;
  }

  String get email {
    return _email;
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<void> getCurrentUser() async {
    String url = 'http://localhost:3000/user/me';

    try {
      final res = await http.get(url, headers: {...requestHeader, 'Authorization': 'Bearer $_token'});
      final responseData = json.decode(res.body);

      _uniqueName = responseData['uniqueName'];
      _nickname = responseData['name'];
      _email = responseData['email'];
      _birthday = DateTime.parse(responseData['birthday']);

      if (_uniqueName == null || _nickname == null || _email == null || _birthday == null) {
        throw HttpException('Failed to get user info');
      }

      notifyListeners();

    } catch (error) {
      throw error;
    }
  }
}