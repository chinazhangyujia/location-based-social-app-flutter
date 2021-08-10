import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/config.dart';

/// provider for current loggin user data
class UserProvider with ChangeNotifier {
  String _id;
  String _nickname;
  String _uniqueName;
  String _email;
  String _introduction;
  String _avatarUrl;

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
      avatarUrl: _avatarUrl,
      introduction: _introduction,
    );
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<User> getCurrentUser() async {
    final String url = '$SERVICE_DOMAIN/user/me';

    try {
      final res = await http.get(Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'});
      if (res.statusCode != 200) {
        throw HttpException(
            'Failed to get login user info. Please try again later');
      }

      final responseData = json.decode(res.body) as Map<String, dynamic>;

      _id = responseData['_id'] as String;
      _uniqueName = responseData['uniqueName'] as String;
      _nickname = responseData['name'] as String;
      _email = responseData['email'] as String;
      _introduction = responseData['introduction'] as String;
      _avatarUrl = responseData['avatarUrl'] as String;

      if (_uniqueName == null ||
          _nickname == null ||
          _email == null) {
        throw HttpException('Failed to get user info. Please try later');
      }

      notifyListeners();

      return User(
          id: _id,
          name: _nickname,
          avatarUrl: _avatarUrl,
          introduction: _introduction);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUserInfo(
      {String selfIntroduction, String avatarUrl}) async {
    final String url = '$SERVICE_DOMAIN/user/updateUserInfo';
    String inputIntroduction;

    // when user update avatar, the self intro will be null. We don't change it.
    // when user remove self intro, the self intro will be passed in as empty string.
    if (selfIntroduction == null) {
      inputIntroduction = _introduction;
    } else if (selfIntroduction.trim().isEmpty) {
      inputIntroduction = null;
    } else {
      inputIntroduction = selfIntroduction;
    }

    final res = await http.post(Uri.parse(url),
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
        body: json.encode({'intro': inputIntroduction, 'avatarUrl': avatarUrl}));

    if (res.statusCode != 200) {
      throw HttpException('Failed to update user info. Please try again later');
    }

    final responseData = json.decode(res.body);
    if ((inputIntroduction != null || avatarUrl != null) &&
        (responseData['nModified'] != 1 || responseData['ok'] != 1)) {
      throw HttpException('Failed to update user info. Please try again later');
    }

    if (_introduction != inputIntroduction) {
      _introduction = inputIntroduction;
    }

    if (avatarUrl != null) {
      _avatarUrl = avatarUrl;
    }

    notifyListeners();
  }

  Future<User> getUserByUniqueName(String uniqueName) async {
    final String url = '$SERVICE_DOMAIN/userByUniqueName/$uniqueName';

    try {
      final res = await http.get(Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'});

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

      final String id = responseData['_id'] as String;
      final String uniqueName = responseData['uniqueName'] as String;
      final String nickname = responseData['name'] as String;
      final String email = responseData['email'] as String;
      final String introduction = responseData['introduction'] as String;
      final String friendStatus = responseData['friendStatus'] as String;
      final String avatarUrl = responseData['avatarUrl'] as String;

      if (uniqueName == null ||
          nickname == null ||
          email == null ||
          friendStatus == null) {
        throw HttpException('Failed to find user. Please try later');
      }

      final User fetchedUser = User(
          id: id,
          name: nickname,
          avatarUrl: avatarUrl,
          introduction: introduction,
          metaData: {'friendStatus': friendStatus});

      return fetchedUser;
    } catch (error) {
      rethrow;
    }
  }
}
