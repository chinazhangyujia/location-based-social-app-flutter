import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/comment.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/config.dart';

/// Provider for comments of posts
class CommentsProvider with ChangeNotifier {
  final Map<String, List<Comment>> _commentsForPost = {};

  String _token;

  void update(String token) {
    _token = token;
  }

  List<Comment> getCommentsForPost(String postId) {
    return _commentsForPost[postId] ?? [];
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<void> getComments(String postId) async {
    final String url = '$SERVICE_DOMAIN/comment/$postId';

    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {...requestHeader},
      );

      if (res.statusCode != 200) {
        return;
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<Comment> fetchedComments = responseData.map((e) {

        final Map<String, dynamic> sendFromData = e['sendFrom'] as Map<String, dynamic>;

        final User sendFrom = User(
            id: sendFromData['_id'] as String,
            name: sendFromData['name'] as String,
            avatarUrl: sendFromData['avatarUrl'] as String,
            introduction: sendFromData['introduction'] as String);

        User sendTo;
        final Map<String, dynamic> sendToData = e['sendTo'] as Map<String, dynamic>;
        if (sendToData != null) {
          sendTo = User(
              id: sendToData['_id'] as String,
              name: sendToData['name'] as String,
              avatarUrl: sendToData['avatarUrl'] as String,
              introduction: sendToData['introduction'] as String);
        }

        return Comment(
            id: e['_id'] as String,
            sendFrom: sendFrom,
            sendTo: sendTo,
            content: e['content'] as String,
            postTime: DateTime.parse(e['createdAt'] as String)
        );
      }).toList();

      _commentsForPost[postId] = fetchedComments;
      notifyListeners();
    }
    catch (error) {
      return;
    }

  }

  Future<void> postComment({
    User sendTo,
    @required String content,
    @required String postId,
    @required User loginUser
  }) async {
    try {
      final String url = '$SERVICE_DOMAIN/comment';

      final res = await http.post(
          Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'content': content,
            'sendTo': sendTo?.id,
            'post': postId
          })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to comment. Please try again later');
      }

      final responseData = json.decode(res.body);

      final Comment createdComment = Comment(
          id: responseData['_id'] as String,
          sendFrom: loginUser,
          sendTo: sendTo,
          content: responseData['content'] as String,
          postTime: DateTime.parse(responseData['createdAt'] as String)
      );

      if (_commentsForPost.containsKey(postId)) {
        _commentsForPost[postId].insert(0, createdComment);
      }
      else {
        _commentsForPost[postId] = [createdComment];
      }

      notifyListeners();
    }
    catch (error)
    {
      rethrow;
    }
  }
}