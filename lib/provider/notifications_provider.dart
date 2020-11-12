import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/comment_notification.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/config.dart';

class NotificationsProvider with ChangeNotifier {
  List<CommentNotification> _commentNotifications = [];

  String _token;

  void update(String token) {
    _token = token;
  }

  List<CommentNotification> get commentNotifications {
    return [..._commentNotifications];
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<void> getUnnotifiedCommentNotifications() async {
    String url = '${SERVICE_DOMAIN}/unnotifiedComments';

    try {
      final res = await http.get(
        url,
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        return;
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<CommentNotification> unnotifiedNotifications = responseData.map((e) {
        Map<String, dynamic> commentData = e['comment'];
        String commentContent = commentData['content'];
        Map<String, dynamic> sendFromUserData = commentData['sendFrom'];
        User sendFrom = User(
            id: sendFromUserData['_id'],
            name: sendFromUserData['name'],
            avatarUrl: sendFromUserData['avatarUrl'],
            birthday: DateTime.parse(sendFromUserData['birthday']),
        );

        CommentType commentType = commentData['sendTo'] == null ? CommentType.COMMENT : CommentType.REPLY;
        return CommentNotification(
          id: e['_id'],
          sendFrom: sendFrom,
          content: commentContent,
          type: commentType,
          time: DateTime.parse(commentData['createdAt']));
      }).toList();

      _commentNotifications = unnotifiedNotifications;
      notifyListeners();
    }
    catch (error) {
      return;
    }
  }

  Future<void> markCommentNotificationsAsNotified(List<String> notificationIds) async {

    try {
      String url = '${SERVICE_DOMAIN}/markNotificationNotified';
      final res = await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'notificationIds': notificationIds,
          })
      );

      if (res.statusCode != 200) {
        return;
      }

      _commentNotifications = [];
      notifyListeners();

    } catch (error) {

    }

  }
}