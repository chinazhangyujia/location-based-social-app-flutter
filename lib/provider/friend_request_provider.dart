import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/friend_request.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/config.dart';

/// provider for friend request
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
    final String url = '$SERVICE_DOMAIN/addFriendRequest';

    try {
      final res = await http.post(
          Uri.parse(url),
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
      rethrow;
    }
  }

  Future<void> fetchPendingRequests() async {
    final String url = '$SERVICE_DOMAIN/pendingRequests';

    try {
      final res = await http.get(
          Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to get friend request. Please try later');
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<FriendRequest> pendingFriendRequests = responseData.map((e) {
        final Map<String, dynamic> sendFrom = e['fromUser'] as Map<String, dynamic>;

        return FriendRequest(
          id: e['_id'] as String,
          sendFrom: User(
              id: sendFrom['_id'] as String,
              name: sendFrom['name'] as String,
              avatarUrl: sendFrom['avatarUrl'] as String,
          ),
          status: e['status'] as String,
          notified: e['notified'] as bool
        );
      }).toList();

      _pendingRequests = pendingFriendRequests;
      _unnotifiedRequests = pendingFriendRequests.where((req) => !req.notified).toList();

      notifyListeners();
    }
    catch (error) {
      rethrow;
    }
  }

  Future<void> markRequestsAsNotified(List<String> requestIds) async {
    final String url = '$SERVICE_DOMAIN/markRequestAsNotified';

    try {
      await http.post(
          Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'requestIds': requestIds
          })
      );

      final List<FriendRequest> afterNotified = [];
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

  /// Accept or reject request
  Future<void> handleRequest(String status, String requestId) async {
    if (status != 'accepted' && status != 'rejected') {
      return;
    }

    final String url = '$SERVICE_DOMAIN/handleFriendRequest';

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
        body: json.encode({
          'requestId': requestId,
          'status': status
        })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to handle friend request. Please try later');
      }

      _pendingRequests.removeWhere((r) => r.id == requestId);

      notifyListeners();
    }
    catch (error) {
      rethrow;
    }
  }

}