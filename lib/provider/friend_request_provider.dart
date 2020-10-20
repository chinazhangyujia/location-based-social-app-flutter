import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/friend_request.dart';
import 'dart:convert';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';

class FriendRequestProvider with ChangeNotifier {
  List<FriendRequest> _unnotifiedFriendRequests = [];

  String _token;

  void update(String token) {
    _token = token;
  }

  List<FriendRequest> get unnotifiedFriendRequests {
    return [..._unnotifiedFriendRequests];
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
      throw error;
    }
  }

  Future<void> fetchUnnotifiedRequest() async {
    String url = 'http://localhost:3000/unnotifiedRequests';

    try {
      final res = await http.get(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to send friend request. Please try later');
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      List<FriendRequest> friendRequests = responseData.map((e) {
        Map<String, dynamic> sendFrom = e['fromUser'];

        return FriendRequest(
          id: e['_id'],
          sendFrom: User(
              id: sendFrom ['_id'],
              name: sendFrom ['name'],
              avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
              birthday: DateTime.parse(sendFrom['birthday']),
              gender: Gender.MALE),
          status: e['status'],
          notified: e['notified']
        );
      }).toList();

      this._unnotifiedFriendRequests = friendRequests;

      notifyListeners();
    }
    catch (error) {
      throw error;
    }
  }

  Future<void> markRequestsAsNotified(List<String> requestIds) async {
    String url = 'http://localhost:3000/markRequestAsNotified';

    try {
      await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'requestIds': requestIds
          })
      );

      _unnotifiedFriendRequests = [];

      notifyListeners();

    }
    catch (error) {
      // don't do anything
    }
  }

}