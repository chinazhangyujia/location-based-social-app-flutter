import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/user_accessor.dart';

class PostsProvider with ChangeNotifier
{
  List<Post> _posts = [];

  String _token;

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  void update(String token) {
    _token = token;
  }

  List<Post> get posts {
    return _posts;
  }

  Future<void> uploadNewPost(String content, List<String> photoUrls) async {

    try {
      String url = 'http://localhost:3000/post';

      final res = await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'content': content,
            'imageUrls': photoUrls
          })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to post. Please try again later');
      }

      final responseData = json.decode(res.body);
      String ownerId = responseData['owner'];

      final userData = await UserAccessor.getUserById(ownerId);

      Post createdPost = Post(
          id: responseData['_id'],
          user: User(
            id:
            userData['_id'],
            name: userData['name'],
            avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
            birthday: DateTime.parse(userData['birthday']),
            gender: Gender.MALE),
          postedTimeStamp: DateTime.parse(responseData['createdAt']),
          photoUrls: responseData['imageUrls'].cast<String>(),
          content: responseData['content']);

      _posts.insert(0, createdPost);
      notifyListeners();
    }
    catch (error)
    {
      print(error);
      throw error;
    }
  }


}