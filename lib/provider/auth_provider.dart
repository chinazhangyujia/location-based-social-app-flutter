import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/util/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }

    return null;
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<bool> tryAutoLogin() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey('auth_data')) {
      return false;
    }

    Map<String, dynamic> authData = json.decode(sharedPreferences.getString('auth_data'));

    if (authData['userId'] == null || authData['token'] == null) {
      return false;
    }

    String url = '${SERVICE_DOMAIN}/user/me';
    try {
      final res = await http.get(url, headers: {...requestHeader, 'Authorization': 'Bearer ${authData['token']}'});
      final responseData = json.decode(res.body);

      if (responseData['_id'] == authData['userId']) {
        _token = authData['token'];
        _userId = authData['userId'];
        notifyListeners();
        return true;
      }

      return false;

    } catch (error) {
      return false;
    }

  }

  Future<void> signup(String email, String password, String name, String birthday) async {
    String url = '${SERVICE_DOMAIN}/user/signup';

    try {
      final res = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'name': name,
        'birthday': birthday
      }), headers: requestHeader);

      final responseData = json.decode(res.body);
      if (res.statusCode != 200) {
        throw HttpException(responseData['message']);
      }
      _userId = responseData['user']['_id'];
      _token = responseData['token'];

      notifyListeners();

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String payload = json.encode({
        'userId': _userId,
        'token': _token
      });
      sharedPreferences.setString('auth_data', payload);

    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    String url = '${SERVICE_DOMAIN}/user/login';

    try {
      final res = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
      }), headers: requestHeader);

      if (res.statusCode != 200) {
        throw HttpException('Failed to login in');
      }

      final responseData = json.decode(res.body);
      _userId = responseData['user']['_id'];
      _token = responseData['token'];

      notifyListeners();

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String payload = json.encode({
        'userId': _userId,
        'token': _token
      });
      sharedPreferences.setString('auth_data', payload);

    } catch(error) {
      throw HttpException('Failed to login in');
    }
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    notifyListeners();

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.remove('auth_data');
  }

}