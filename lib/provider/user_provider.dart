import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/config.dart';

class UserProvider with ChangeNotifier {
  String _id;
  String _nickname;
  String _uniqueName;
  DateTime _birthday;
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
      birthday: _birthday,
      introduction: _introduction,
    );
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<User> getCurrentUser() async {
    String url = '${SERVICE_DOMAIN}/user/me';

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
      _avatarUrl = responseData['avatarUrl'];

      if (_uniqueName == null || _nickname == null || _email == null || _birthday == null) {
        throw HttpException('Failed to get user info. Please try later');
      }

      notifyListeners();

      return User(id: _id,
        name: _nickname,
        avatarUrl: _avatarUrl,
        birthday: _birthday,
        introduction: _introduction
      );

    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUserInfo({String selfIntroduction, String avatarUrl}) async {
    String url = '${SERVICE_DOMAIN}/user/updateUserInfo';

    // when user update avatar, the self intro will be null. We don't change it.
    // when user remove self intro, the self intro will be passed in as empty string.
    if (selfIntroduction == null) {
      selfIntroduction = _introduction;
    }
    else if (selfIntroduction.trim().isEmpty) {
      selfIntroduction = null;
    }

    final res = await http.post(
        url,
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
        body: json.encode({
          'intro': selfIntroduction,
          'avatarUrl': avatarUrl
        })
    );

    if (res.statusCode != 200) {
      throw HttpException('Failed to update user info. Please try again later');
    }

    final responseData = json.decode(res.body);
    if ((selfIntroduction != null || avatarUrl != null) && (responseData['nModified'] != 1 || responseData['ok'] != 1)) {
      throw HttpException('Failed to update user info. Please try again later');
    }

    if (_introduction != selfIntroduction) {
      _introduction = selfIntroduction;
    }

    if (avatarUrl != null) {
      _avatarUrl = avatarUrl;
    }

    notifyListeners();
  }

  Future<User> getUserByUniqueName(String uniqueName) async {
    String url = '${SERVICE_DOMAIN}/userByUniqueName/$uniqueName';

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
      String friendStatus = responseData['friendStatus'];
      String avatarUrl = responseData['avatarUrl'];

      if (uniqueName == null || nickname == null || email == null || birthday == null || friendStatus == null) {
        throw HttpException('Failed to find user. Please try later');
      }

      User fetchedUser = User(id: id,
          name: nickname,
          avatarUrl: avatarUrl,
          birthday: birthday,
          introduction: introduction,
          metaData: {'friendStatus': friendStatus }
      );

      return fetchedUser;

    } catch (error) {
      throw error;
    }
  }
}