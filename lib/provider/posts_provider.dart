import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/location_point.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/config.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _nearbyPosts = [];
  List<Post> _friendPosts = [];
  List<Post> _myPosts = [];
  List<Post> _likedPosts = [];
  List<Post> _mapViewPosts = [];

  String _token;

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  void update(String token) {
    _token = token;
  }

  List<Post> get nearbyPosts {
    return _nearbyPosts;
  }

  List<Post> get mapViewPosts {
    return _mapViewPosts;
  }

  List<Post> get friendPosts {
    return _friendPosts;
  }

  List<Post> get myPosts {
    return _myPosts;
  }

  List<Post> get likedPosts {
    return _likedPosts;
  }

  Future<List<Post>> fetchPosts(
      {int fetchSize = 5,
      bool refresh = false,
      LocationPoint location,
      bool isNearby}) async {
    try {
      List<Post> posts;
      if (isNearby) {
        posts = _nearbyPosts;
      } else {
        posts = _mapViewPosts;
      }

      String url =
          '$SERVICE_DOMAIN/allPosts?long=${location.longitude}&lat=${location.latitude}';
      if (fetchSize != null) {
        url += '&fetchSize=$fetchSize';
        if (posts.isNotEmpty && !refresh) {
          url += '&fromId=${posts.last.id}';
        }
      }

      final res = await http.get(Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'});

      if (res.statusCode != 200) {
        throw HttpException('Failed to fetch posts');
      }

      final responseData = json.decode(res.body) as List<dynamic>;
      final List<Post> fetchedPosts = _responseDataToPosts(responseData);

      if (!refresh) {
        posts.addAll(fetchedPosts);
      } else {
        posts = fetchedPosts;
      }

      if (isNearby) {
        _nearbyPosts = posts;
      } else {
        _mapViewPosts = posts;
      }

      notifyListeners();

      return fetchedPosts;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchFriendPosts(
      {int fetchSize = 5, bool refresh = false}) async {
    try {
      String url = '$SERVICE_DOMAIN/friendPosts';

      if (fetchSize != null) {
        url += '?fetchSize=$fetchSize';
        if (_friendPosts.isNotEmpty && !refresh) {
          url += '&fromId=${_friendPosts.last.id}';
        }
      }

      final res = await http.get(Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'});

      if (res.statusCode != 200) {
        throw HttpException('Failed to fetch posts');
      }

      final responseData = json.decode(res.body) as List<dynamic>;
      final List<Post> fetchedPosts = _responseDataToPosts(responseData);

      if (!refresh) {
        _friendPosts.addAll(fetchedPosts);
      } else {
        _friendPosts = fetchedPosts;
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchMyPosts({int fetchSize = 5, bool refresh = false}) async {
    try {
      String url = '$SERVICE_DOMAIN/myPosts';

      if (fetchSize != null) {
        url += '?fetchSize=$fetchSize';
        if (_myPosts.isNotEmpty && !refresh) {
          url += '&fromId=${_myPosts.last.id}';
        }
      }

      final res = await http.get(Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'});

      if (res.statusCode != 200) {
        throw HttpException('Failed to fetch posts');
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<Post> fetchedPosts = _responseDataToPosts(responseData);
      if (!refresh) {
        _myPosts.addAll(fetchedPosts);
      } else {
        _myPosts = fetchedPosts;
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchLikedPosts(
      {int fetchSize = 5, bool refresh = false}) async {
    try {
      String url = '$SERVICE_DOMAIN/likedPosts';

      if (fetchSize != null) {
        url += '?fetchSize=$fetchSize';
        if (_likedPosts.isNotEmpty && !refresh) {
          url += '&fromId=${_likedPosts.last.id}';
        }
      }

      final res = await http.get(Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'});

      if (res.statusCode != 200) {
        throw HttpException('Failed to fetch posts');
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<Post> fetchedPosts = _responseDataToPosts(responseData);
      if (!refresh) {
        _likedPosts.addAll(fetchedPosts);
      } else {
        _likedPosts = fetchedPosts;
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> uploadNewPost(
      String content, List<String> photoUrls, User loginUser) async {
    try {
      final Location locationTracker = Location();
      final LocationData currentLocation = await locationTracker.getLocation();

      final String url = '$SERVICE_DOMAIN/post';

      final res = await http.post(Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'content': content,
            'imageUrls': photoUrls,
            'location': {
              'type': 'Point',
              'coordinates': [
                currentLocation.longitude,
                currentLocation.latitude
              ]
            }
          }));

      if (res.statusCode != 200) {
        throw HttpException('Failed to post. Please try again later');
      }

      final responseData = json.decode(res.body);

      final Post createdPost = Post(
          id: responseData['_id'] as String,
          user: loginUser,
          postedTimeStamp: DateTime.parse(responseData['createdAt'] as String),
          photoUrls: responseData['imageUrls'].cast<String>() as List<String>,
          content: responseData['content'] as String,
          postLocation: LocationPoint(
              currentLocation.longitude, currentLocation.latitude),
          likesCount: 0,
          userLiked: false);

      _nearbyPosts.insert(0, createdPost);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  /// Like or dislike post
  Future<void> likePost(String postId, bool like) async {
    final String url = '$SERVICE_DOMAIN/likePost';

    try {
      final res = await http.post(Uri.parse(url),
          headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
          body: json.encode({
            'postId': postId,
            'like': like,
          }));

      if (res.statusCode != 200) {
        throw HttpException('Failed like the post. Please try again later');
      }

      _changeLikeInPosts(_nearbyPosts, postId, like);
      _changeLikeInPosts(_mapViewPosts, postId, like);
      _changeLikeInPosts(_friendPosts, postId, like);
      _changeLikeInPosts(_myPosts, postId, like);
      _changeLikeInPosts(_likedPosts, postId, like);

      notifyListeners();
    } catch (error) {}
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

  List<Post> _responseDataToPosts(List<dynamic> responseData) {
    final List<Post> fetchedPosts = responseData.map((e) {
      final Map<String, dynamic> userData = e['owner'] as Map<String, dynamic>;
      final List<dynamic> postLocation = e['location']['coordinates'] as List<dynamic>;
      final double longitude =
          postLocation[0] is int ? postLocation[0].toDouble() as double : postLocation[0] as double;
      final double latitude =
          postLocation[1] is int ? postLocation[1].toDouble() as double : postLocation[1] as double;

      return Post(
          id: e['_id'] as String,
          user: User(
              id: userData['_id'] as String,
              name: userData['name'] as String,
              avatarUrl: userData['avatarUrl'] as String,
              birthday: DateTime.parse(userData['birthday'] as String),
              introduction: userData['introduction'] as String),
          postedTimeStamp: DateTime.parse(e['createdAt'] as String),
          photoUrls: e['imageUrls'].cast<String>() as List<String>,
          content: e['content'] as String,
          postLocation: LocationPoint(longitude, latitude),
          likesCount: e['likesCount'] as int,
          userLiked: e['userLiked'] as bool);
    }).toList();

    return fetchedPosts;
  }
}
