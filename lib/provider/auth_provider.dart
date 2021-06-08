import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/util/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The provider for authentication ralated data and sevice call
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

  /// when user open this app, we call this method to try to auto sign in.
  /// If success, we show home screen. Otherwise, we will show user login screen.
  Future<bool> tryAutoLogin() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey('auth_data')) {
      return false;
    }

    final Map<String, dynamic> authData = json.decode(sharedPreferences.getString('auth_data')) as Map<String, dynamic>;

    if (authData['userId'] == null || authData['token'] == null) {
      return false;
    }

    final String url = '$SERVICE_DOMAIN/user/me';
    try {
      final res = await http.get(Uri.parse(url), headers: {...requestHeader, 'Authorization': 'Bearer ${authData['token']}'});
      final responseData = json.decode(res.body);

      if (responseData['_id'] == authData['userId']) {
        _token = authData['token'] as String;
        _userId = authData['userId'] as String;
        notifyListeners();
        return true;
      }

      return false;

    } catch (error) {
      return false;
    }

  }

  Future<void> signup(String email, String password, String name, String birthday) async {
    final String url = '$SERVICE_DOMAIN/user/signup';

    try {
      final res = await http.post(Uri.parse(url), body: json.encode({
        'email': email,
        'password': password,
        'name': name,
        'birthday': birthday
      }), headers: requestHeader);

      final responseData = json.decode(res.body);
      if (res.statusCode != 200) {
        throw HttpException(responseData['message'] as String);
      }
      _userId = responseData['user']['_id'] as String;
      _token = responseData['token'] as String;

      notifyListeners();

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final String payload = json.encode({
        'userId': _userId,
        'token': _token
      });
      sharedPreferences.setString('auth_data', payload);

    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    final String url = '$SERVICE_DOMAIN/user/login';

    try {
      final res = await http.post(Uri.parse(url), body: json.encode({
        'email': email,
        'password': password,
      }), headers: requestHeader);

      if (res.statusCode != 200) {
        throw HttpException('Failed to login in');
      }

      final responseData = json.decode(res.body);
      _userId = responseData['user']['_id'] as String;
      _token = responseData['token'] as String;

      notifyListeners();

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final String payload = json.encode({
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