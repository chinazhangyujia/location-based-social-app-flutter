import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/location_point.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';

class PostsProvider with ChangeNotifier
{
  List<Post> _posts = [];
  List<Post> _friendPosts = [];
  List<Post> _postsWithUnnotifiedComment = [];

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

  List<Post> get friendPosts {
    return _friendPosts;
  }

  List<Post> get postsWithUnnotifiedComment {
    return _postsWithUnnotifiedComment;
  }

  Future<List<Post>> fetchPosts() async {
    try {
      Location locationTracker = Location();
      LocationData currentLocation = await locationTracker.getLocation();

      String url = 'http://localhost:3000/allPosts?long=${currentLocation.longitude}&lat=${currentLocation.latitude}';

      final res = await http.get(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'}
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to fetch posts');
      }

      final responseData = json.decode(res.body) as List<dynamic>;
      final List<Post> fetchedPosts = responseData.map((e) {

        Map<String, dynamic> userData = e['owner'];
        Map<String, dynamic> postLocation = e['location'];

        return Post(
          id: e['_id'],
          user: User(
              id: userData['_id'],
              name: userData['name'],
              avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
              birthday: DateTime.parse(userData['birthday']),
              gender: Gender.MALE),
          postedTimeStamp: DateTime.parse(e['createdAt']),
          photoUrls: e['imageUrls'].cast<String>(),
          content: e['content'],
          postLocation: LocationPoint(postLocation['coordinates'][0], postLocation['coordinates'][1]),
          likesCount: e['likesCount'],
          userLiked: e['userLiked']
        );
      }).toList();

      _posts = fetchedPosts;

      notifyListeners();

      return fetchedPosts;
    }
    catch (error)
    {
      throw error;
    }
  }

  Future<void> fetchFriendPosts() async {
    try {

      String url = 'http://localhost:3000/friendPosts';

      final res = await http.get(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'}
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to fetch posts');
      }

      final responseData = json.decode(res.body) as List<dynamic>;
      final List<Post> fetchedPosts = responseData.map((e) {

        Map<String, dynamic> userData = e['owner'];
        List<dynamic> postLocation = e['location']['coordinates'];
        double longitude = postLocation[0] is int ? postLocation[0].toDouble() : postLocation[0];
        double latitude = postLocation[1] is int ? postLocation[1].toDouble() : postLocation[1];

        return Post(
            id: e['_id'],
            user: User(
                id: userData['_id'],
                name: userData['name'],
                avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
                birthday: DateTime.parse(userData['birthday']),
                gender: Gender.MALE),
            postedTimeStamp: DateTime.parse(e['createdAt']),
            photoUrls: e['imageUrls'].cast<String>(),
            content: e['content'],
            postLocation: LocationPoint(longitude, latitude),
            likesCount: e['likesCount'],
            userLiked: e['userLiked']
        );
      }).toList();

      _friendPosts = fetchedPosts;

      notifyListeners();

    }
    catch (error)
    {
      throw error;
    }
  }

  Future<void> fetchPostsWithUnnotifiedComment() async {
    try {

      String url = 'http://localhost:3000/postWithUnnotifiedComment';

      final res = await http.get(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'}
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to fetch posts');
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<Post> fetchedPosts = responseData.map((e) {

        Map<String, dynamic> userData = e['owner'];
        List<dynamic> postLocation = e['location']['coordinates'];
        double longitude = postLocation[0] is int ? postLocation[0].toDouble() : postLocation[0];
        double latitude = postLocation[1] is int ? postLocation[1].toDouble() : postLocation[1];

        return Post(
            id: e['_id'],
            user: User(
                id: userData['_id'],
                name: userData['name'],
                avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
                birthday: DateTime.parse(userData['birthday']),
                gender: Gender.MALE),
            postedTimeStamp: DateTime.parse(e['createdAt']),
            photoUrls: e['imageUrls'].cast<String>(),
            content: e['content'],
            postLocation: LocationPoint(longitude, latitude),
            likesCount: e['likesCount'],
            userLiked: e['userLiked']
        );
      }).toList();

      _postsWithUnnotifiedComment = fetchedPosts;

      notifyListeners();
    }
    catch (error)
    {
      throw error;
    }
  }

  Future<void> markPostsAsNotified(List<String> postIds) async {

    try {
      String url = 'http://localhost:3000/markNotificationNotified';
      final res = await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'postIds': postIds,
          })
      );

      if (res.statusCode != 200) {
        return;
      }

      _postsWithUnnotifiedComment = [];
      notifyListeners();

    } catch (error) {

    }

  }

  Future<void> uploadNewPost(String content, List<String> photoUrls, User loginUser) async {

    try {
      Location locationTracker = Location();
      LocationData currentLocation = await locationTracker.getLocation();

      String url = 'http://localhost:3000/post';

      final res = await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'content': content,
            'imageUrls': photoUrls,
            'location': {'type': 'Point', 'coordinates': [currentLocation.longitude, currentLocation.latitude]}
          })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed to post. Please try again later');
      }

      final responseData = json.decode(res.body);

      Post createdPost = Post(
        id: responseData['_id'],
        user: loginUser,
        postedTimeStamp: DateTime.parse(responseData['createdAt']),
        photoUrls: responseData['imageUrls'].cast<String>(),
        content: responseData['content'],
        postLocation: LocationPoint(currentLocation.longitude, currentLocation.latitude),
        likesCount: 0,
        userLiked: false
      );

      _posts.insert(0, createdPost);
      notifyListeners();
    }
    catch (error)
    {
      throw error;
    }
  }

  /**
   * Like or dislike post
   */
  Future<void> likePost(String postId, bool like) async {
    String url = 'http://localhost:3000/likePost';

    try {
      final res = await http.post(
          url,
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'postId': postId,
            'like': like,
          })
      );

      if (res.statusCode != 200) {
        throw HttpException('Failed like the post. Please try again later');
      }

      _changeLikeInPosts(_posts, postId, like);
      _changeLikeInPosts(_friendPosts, postId, like);
      _changeLikeInPosts(_postsWithUnnotifiedComment, postId, like);

      notifyListeners();

    } catch (error) {

    }

  }

  void _changeLikeInPosts(List<Post> posts, String postId, bool like) {
    posts.forEach((element) {
      if (element.id == postId) {
        if (like && !element.userLiked) {
          element.userLiked = like;
          element.likesCount++;
        } else if (!like && element.userLiked) {
          element.userLiked = like;
          element.likesCount--;
        }
      }
    });
  }
}