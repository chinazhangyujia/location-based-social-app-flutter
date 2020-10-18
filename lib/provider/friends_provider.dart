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

  Future<void> sendFriendRequest(String targetUserId) async {
    String url = 'http://localhost:3000/addFriendRequest';

    try {
      final res = await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'toUser': targetUserId
          })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to send friend request. Please try later');
      }
    }
    catch (error) {
      print(error);
      throw error;
    }
  }

}