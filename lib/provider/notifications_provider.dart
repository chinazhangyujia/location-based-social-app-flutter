import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/post_notification.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/config.dart';

class NotificationsProvider with ChangeNotifier {
  List<PostNotification> _postNotifications = [];

  String _token;

  void update(String token) {
    _token = token;
  }

  List<PostNotification> get allNotifications {
    return [..._postNotifications];
  }

  List<PostNotification> get commentNotifications {
    return _postNotifications.where((element) => element.type == NotificationType.COMMENT).toList();
  }

  List<PostNotification> get likeNotifications {
    return _postNotifications.where((element) => element.type == NotificationType.LIKE).toList();
  }

  int get unnotifiedNotificationsCount {
    return _postNotifications.where((element) => !element.notified).length;
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<void> getAllNotifications() async {
    String url = '${SERVICE_DOMAIN}/allNotifications';

    try {
      final res = await http.get(
        url,
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        return;
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<PostNotification> notifications = responseData.map((e) {
        NotificationType notificationType = e['type'] == 'comment' ? NotificationType.COMMENT : NotificationType.LIKE;

        if (notificationType == NotificationType.COMMENT) {
          Map<String, dynamic> commentData = e['comment'];
          String commentContent = commentData['content'];
          Map<String, dynamic> sendFromUserData = commentData['sendFrom'];
          User sendFrom = User(
            id: sendFromUserData['_id'],
            name: sendFromUserData['name'],
            avatarUrl: sendFromUserData['avatarUrl'],
            birthday: DateTime.parse(sendFromUserData['birthday']),
          );

          return PostNotification(
              id: e['_id'],
              sendFrom: sendFrom,
              content: commentContent,
              type: notificationType,
              notified: e['notified'],
              time: DateTime.parse(commentData['createdAt']));
        }
        else {
          Map<String, dynamic> sendFromUserData = e['fromUser'];

          User sendFrom = User(
            id: sendFromUserData['_id'],
            name: sendFromUserData['name'],
            avatarUrl: sendFromUserData['avatarUrl'],
            birthday: DateTime.parse(sendFromUserData['birthday']),
          );

          return PostNotification(
              id: e['_id'],
              sendFrom: sendFrom,
              content: '${sendFrom.name} liked your post',
              type: notificationType,
              notified: e['notified'],
              time: DateTime.parse(e['createdAt']));
        }

      }).toList();

      _postNotifications = notifications;
      notifyListeners();
    }
    catch (error) {
      return;
    }
  }

  Future<void> markNotificationsAsNotified(List<String> commentNotificationIds, List<String> likeNotificationIds) async {

    if (commentNotificationIds.isEmpty && likeNotificationIds.isEmpty) {
      return;
    }

    try {
      String url = '${SERVICE_DOMAIN}/markNotificationNotified';
      final res = await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'commentNotificationIds': commentNotificationIds,
            'likeNotificationIds': likeNotificationIds
          })
      );

      if (res.statusCode != 200) {
        return;
      }

      _postNotifications.forEach((element) {
        element.notified = true;
      });

      notifyListeners();

    } catch (error) {

    }

  }
}