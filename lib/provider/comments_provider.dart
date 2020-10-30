import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/comment.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';

class CommentsProvider with ChangeNotifier {
  Map<String, List<Comment>> _commentsForPost = Map();

  String _token;

  void update(String token) {
    _token = token;
  }

  List<Comment> getCommentsForPost(String postId) {
    return _commentsForPost[postId] != null ? _commentsForPost[postId] : [];
  }

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  Future<void> getComments(String postId) async {
    String url = 'http://localhost:3000/comment/$postId';

    try {
      final res = await http.get(
        url,
        headers: {...requestHeader},
      );

      if (res.statusCode != 200) {
        return;
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<Comment> fetchedComments = responseData.map((e) {

        Map<String, dynamic> sendFromData = e['sendFrom'];

        User sendFrom = User(
            id: sendFromData['_id'],
            name: sendFromData['name'],
            avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
            birthday: DateTime.parse(sendFromData['birthday']),
            gender: Gender.MALE);

        User sendTo = null;
        Map<String, dynamic> sendToData = e['sendTo'];
        if (sendToData != null) {
          sendTo = User(
              id: sendToData['_id'],
              name: sendToData['name'],
              avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
              birthday: DateTime.parse(sendToData['birthday']),
              gender: Gender.MALE);
        }

        return Comment(
            id: e['_id'],
            sendFrom: sendFrom,
            sendTo: sendTo,
            content: e['content'],
            postTime: DateTime.parse(e['createdAt'])
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
      String url = 'http://localhost:3000/comment';

      final res = await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'content': content,
            'sendTo': sendTo == null ? null : sendTo.id,
            'post': postId
          })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to comment. Please try again later');
      }

      final responseData = json.decode(res.body);

      Comment createdComment = Comment(
          id: responseData['_id'],
          sendFrom: loginUser,
          sendTo: sendTo,
          content: responseData['content'],
          postTime: DateTime.parse(responseData['createdAt'])
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
      throw error;
    }
  }
}