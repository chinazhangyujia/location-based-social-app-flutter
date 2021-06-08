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
    return _postNotifications
        .where((element) => element.type == NotificationType.COMMENT)
        .toList();
  }

  List<PostNotification> get likeNotifications {
    return _postNotifications
        .where((element) => element.type == NotificationType.LIKE)
        .toList();
  }

  int get unnotifiedNotificationsCount {
    return _postNotifications.where((element) => !element.notified).length;
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<void> getAllNotifications() async {
    final String url = '$SERVICE_DOMAIN/allNotifications';

    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        return;
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<PostNotification> notifications = responseData.map((e) {
        final NotificationType notificationType = e['type'] == 'comment'
            ? NotificationType.COMMENT
            : NotificationType.LIKE;

        if (notificationType == NotificationType.COMMENT) {
          final Map<String, dynamic> commentData =
              e['comment'] as Map<String, dynamic>;
          final String commentContent = commentData['content'] as String;
          final Map<String, dynamic> sendFromUserData =
              commentData['sendFrom'] as Map<String, dynamic>;
          final User sendFrom = User(
            id: sendFromUserData['_id'] as String,
            name: sendFromUserData['name'] as String,
            avatarUrl: sendFromUserData['avatarUrl'] as String,
            birthday: DateTime.parse(sendFromUserData['birthday'] as String),
          );

          return PostNotification(
              id: e['_id'] as String,
              sendFrom: sendFrom,
              content: commentContent,
              type: notificationType,
              notified: e['notified'] as bool,
              time: DateTime.parse(commentData['createdAt'] as String));
        } else {
          final Map<String, dynamic> sendFromUserData =
              e['fromUser'] as Map<String, dynamic>;

          final User sendFrom = User(
            id: sendFromUserData['_id'] as String,
            name: sendFromUserData['name'] as String,
            avatarUrl: sendFromUserData['avatarUrl'] as String,
            birthday: DateTime.parse(sendFromUserData['birthday'] as String),
          );

          return PostNotification(
              id: e['_id'] as String,
              sendFrom: sendFrom,
              content: '${sendFrom.name} liked your post',
              type: notificationType,
              notified: e['notified'] as bool,
              time: DateTime.parse(e['createdAt'] as String));
        }
      }).toList();

      _postNotifications = notifications;
      notifyListeners();
    } catch (error) {
      return;
    }
  }

  Future<void> markNotificationsAsNotified(List<String> commentNotificationIds,
      List<String> likeNotificationIds) async {
    if (commentNotificationIds.isEmpty && likeNotificationIds.isEmpty) {
      return;
    }

    try {
      final String url = '$SERVICE_DOMAIN/markNotificationNotified';
      final res = await http.post(Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'commentNotificationIds': commentNotificationIds,
            'likeNotificationIds': likeNotificationIds
          }));

      if (res.statusCode != 200) {
        return;
      }

      _postNotifications.forEach((element) {
        element.notified = true;
      });

      notifyListeners();
    } catch (error) {}
  }
}
