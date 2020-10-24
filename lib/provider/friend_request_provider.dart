import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/friend_request.dart';
import 'dart:convert';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/screen/post_detail_screen.dart';

class FriendRequestProvider with ChangeNotifier {
  List<FriendRequest> _pendingRequests = [];

  List<FriendRequest> _unnotifiedRequests = [];

  String _token;

  void update(String token) {
    _token = token;
  }

  List<FriendRequest> get pendingRequests {
    return [..._pendingRequests];
  }

  List<FriendRequest> get unnotifiedRequests {
    return [..._unnotifiedRequests];
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

  Future<void> fetchPendingRequests() async {
    String url = 'http://localhost:3000/pendingRequests';

    try {
      final res = await http.get(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to get friend request. Please try later');
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      List<FriendRequest> pendingFriendRequests = responseData.map((e) {
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

      this._pendingRequests = pendingFriendRequests;
      this._unnotifiedRequests = pendingFriendRequests.where((req) => !req.notified).toList();

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

      List<FriendRequest> afterNotified = [];
      _pendingRequests.forEach((element) {
        if (element.notified || !requestIds.contains(element.id)) {
          afterNotified.add(element);
        }
        else {
          afterNotified.add(
            FriendRequest(
              id: element.id,
              sendFrom: element.sendFrom,
              status: element.status,
              notified: true
            )
          );
        }
      });

      _pendingRequests = afterNotified;

      _unnotifiedRequests = [];

      notifyListeners();

    }
    catch (error) {
      // don't do anything
    }
  }

  /**
   * Accept or deny request
   */
  Future<void> handleRequest(String status, String requestId) async {
    if (status != 'accepted' && status != 'denied') {
      return;
    }

    String url = 'http://localhost:3000/handleFriendRequest';

    try {
      final res = await http.post(
        url,
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
        body: json.encode({
          'requestId': requestId,
          'status': status
        })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to handle friend request. Please try later');
      }

      // todo refresh friends list.
      _pendingRequests.removeWhere((r) => r.id == requestId);

      notifyListeners();
    }
    catch (error) {
      throw error;
    }
  }

}