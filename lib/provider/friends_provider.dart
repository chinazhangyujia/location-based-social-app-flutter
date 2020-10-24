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

  Future<void> getAllFriends() async {
    String url = 'http://localhost:3000/friends';

    try {
      final res = await http.get(
        url,
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to fetch friend. Please try later');
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      List<User> friends = responseData.map((e) {
        Map<String, dynamic> friend = e['friendUser'];

        return User(
            id: friend['_id'],
            name: friend['name'],
            avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
            birthday: DateTime.parse(friend['birthday']),
            gender: Gender.MALE);
      }).toList();

      this._friends = friends;

      notifyListeners();
    }
    catch (error) {
      throw error;
    }
  }

}