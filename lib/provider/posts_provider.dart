import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/location_point.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_social_app/model/user.dart';

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

  Future<List<Post>> fetchPosts() async {
    try {
      Location locationTracker = Location();
      LocationData currentLocation = await locationTracker.getLocation();

      String url = 'http://localhost:3000/allPosts?long=${currentLocation.longitude}&lat=${currentLocation.latitude}';

      final res = await http.get(
          url,
          headers: {...requestHeader}
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
          postLocation: LocationPoint(postLocation['coordinates'][0], postLocation['coordinates'][1])
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
        postLocation: LocationPoint(currentLocation.longitude, currentLocation.latitude)
      );

      _posts.insert(0, createdPost);
      notifyListeners();
    }
    catch (error)
    {
      throw error;
    }
  }
}