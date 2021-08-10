import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/util/config.dart';

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
    final String url = '$SERVICE_DOMAIN/friends';

    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to fetch friend. Please try later');
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<User> friends = responseData.map((e) {
        final Map<String, dynamic> friend = e['friendUser'] as Map<String, dynamic>;

        return User(
            id: friend['_id'] as String,
            name: friend['name'] as String,
            avatarUrl: friend['avatarUrl'] as String,
        );
      }).toList();

      _friends = friends;

      notifyListeners();
    }
    catch (error) {
      rethrow;
    }
  }

  Future<String> getFriendStatus(String targetUserId) async {
    final String url = '$SERVICE_DOMAIN/friendStatus?user=$targetUserId';

    try {
      final res = await http.get(
          Uri.parse(url),
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
    final String url = '$SERVICE_DOMAIN/cancelFriendship';

    try {
      final res = await http.post(
          Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'friendUser': friendUserId
          })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to send friend request. Please try later');
      }

      final responseData = json.decode(res.body) as Map<String, dynamic>;
      final String updatedFriendUserId = responseData['friendUser'] as String;

      _friends.removeWhere((element) => element.id == updatedFriendUserId);
      notifyListeners();
    }
    catch (error) {
      rethrow;
    }
  }

}