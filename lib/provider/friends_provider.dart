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
            avatarUrl: friend['avatarUrl'],
            birthday: DateTime.parse(friend['birthday']),
        );
      }).toList();

      this._friends = friends;

      notifyListeners();
    }
    catch (error) {
      throw error;
    }
  }

  Future<String> getFriendStatus(String targetUserId) async {
    String url = 'http://localhost:3000/friendStatus?user=${targetUserId}';

    try {
      final res = await http.get(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        return 'N/A';
      }

      return res.body;
    }
    catch (error) {
      return 'N/A';
    }
  }

  Future<void> cancelFriendship(String friendUserId) async {
    String url = 'http://localhost:3000/cancelFriendship';

    try {
      final res = await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'friendUser': friendUserId
          })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to send friend request. Please try later');
      }

      final responseData = json.decode(res.body) as Map<String, dynamic>;
      String updatedFriendUserId = responseData['friendUser'];

      _friends.removeWhere((element) => element.id == updatedFriendUserId);
      notifyListeners();
    }
    catch (error) {
      throw error;
    }
  }

}