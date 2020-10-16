import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/user.dart';

class UserProvider with ChangeNotifier {
  String _id;
  String _nickname;
  String _uniqueName;
  DateTime _birthday;
  String _email;
  String _introduction;

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

  String get introduction {
    return _introduction;
  }

  User get loginUser {
    if (_id == null) {
      return null;
    }

    return User(
      id: _id,
      name: _nickname,
      avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
      birthday: _birthday,
      gender: Gender.MALE,
      introduction: _introduction,
    );
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<User> getCurrentUser() async {
    String url = 'http://localhost:3000/user/me';

    try {
      final res = await http.get(url, headers: {...requestHeader, 'Authorization': 'Bearer $_token'});
      if (res.statusCode != 200) {
        throw HttpException('Failed to get login user info. Please try again later');
      }

      final responseData = json.decode(res.body) as Map<String, dynamic>;

      _id = responseData['_id'];
      _uniqueName = responseData['uniqueName'];
      _nickname = responseData['name'];
      _email = responseData['email'];
      _birthday = DateTime.parse(responseData['birthday']);
      _introduction = responseData['introduction'];

      if (_uniqueName == null || _nickname == null || _email == null || _birthday == null) {
        throw HttpException('Failed to get user info. Please try later');
      }

      notifyListeners();

      return User(id: _id,
        name: _nickname,
        avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
        birthday: _birthday,
        gender: Gender.MALE,
        introduction: _introduction
      );

    } catch (error) {
      throw error;
    }
  }

  Future<void> updateSelfIntroduction(String selfIntroduction) async {
    String url = 'http://localhost:3000/user/intro';

    if (selfIntroduction == null || selfIntroduction.trim().isEmpty) {
      selfIntroduction = null;
    }

    final res = await http.post(
        url,
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
        body: json.encode({
          'intro': selfIntroduction
        })
    );

    if (res.statusCode != 200) {
      throw HttpException('Failed to update self introduction. Please try again later');
    }

    final responseData = json.decode(res.body);
    if (responseData['nModified'] != 1 || responseData['ok'] != 1) {
      throw HttpException('Failed to update self introduction. Please try again later');
    }

    _introduction = selfIntroduction;
    notifyListeners();
  }

  Future<User> getUserByUniqueName(String uniqueName) async {
    String url = 'http://localhost:3000/userByUniqueName/$uniqueName';

    try {
      final res = await http.get(url, headers: {...requestHeader, 'Authorization': 'Bearer $_token'});

      if (res.statusCode != 200) {
        throw HttpException('Failed to find user. Please try again later');
      }


      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final responseData = json.decode(res.body) as Map<String, dynamic>;

      if (responseData.isEmpty) {
        return null;
      }

      String id = responseData['_id'];
      String uniqueName = responseData['uniqueName'];
      String nickname = responseData['name'];
      String email = responseData['email'];
      DateTime birthday = DateTime.parse(responseData['birthday']);
      String introduction = responseData['introduction'];

      if (uniqueName == null || nickname == null || email == null || birthday == null) {
        throw HttpException('Failed to find user. Please try later');
      }

      return User(id: id,
          name: nickname,
          avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
          birthday: birthday,
          gender: Gender.MALE,
          introduction: introduction
      );

    } catch (error) {
      throw error;
    }
  }
}