import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:location_based_social_app/model/location_point.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/screen/pick_location_map_screen.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapViewPostsScreen extends StatefulWidget {
  static const String cacheKey = 'map_view_previous_selected_location';

  @override
  _MapViewPostsScreenState createState() => _MapViewPostsScreenState();
}

class _MapViewPostsScreenState extends State<MapViewPostsScreen> {
  LocationPoint _selectedLocation;
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getInitialLocation().then((location) {
      _setLocation(location);

      final postsProvider = Provider.of<PostsProvider>(context, listen: false);

      _scrollController.addListener(() {
        if (!_loading &&
            _scrollController.position.maxScrollExtent ==
                _scrollController.position.pixels) {
          setState(() {
            _loading = true;
          });

          postsProvider
              .fetchPosts(refresh: false, location: location, isNearby: false)
              .then((_) {
            setState(() {
              _loading = false;
            });
          });
        }
      });
    });
  }

  Future<LocationPoint> _getInitialLocation() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(MapViewPostsScreen.cacheKey)) {
      final Map<String, dynamic> locationData =
          json.decode(sharedPreferences.getString(MapViewPostsScreen.cacheKey)) as Map<String, dynamic>;

      return LocationPoint(locationData['longitude'] as double, locationData['latitude'] as double);
    } else {
      final Location locationTracker = Location();
      final LocationData currentLocation = await locationTracker.getLocation();
      return LocationPoint(currentLocation.longitude, currentLocation.latitude);
    }
  }

  Future<void> onRefresh() async {
    try {
      Provider.of<PostsProvider>(context, listen: false).fetchPosts(
          refresh: true, location: _selectedLocation, isNearby: false);
    } catch (error) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setLocation(LocationPoint location) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String payload = json.encode(
        {'longitude': location.longitude, 'latitude': location.latitude});
    sharedPreferences.setString(MapViewPostsScreen.cacheKey, payload);
    _selectedLocation = location;

    try {
      Provider.of<PostsProvider>(context, listen: false)
          .fetchPosts(refresh: true, location: location, isNearby: false);
    } catch (error) {}
  }

  void onClickMap(BuildContext context) async {
    if (_selectedLocation == null) {
      return;
    }

    Navigator.of(context).pushNamed(PickLocationMapScreen.router, arguments: {
      'initialLocation': LocationPoint(
          _selectedLocation.longitude, _selectedLocation.latitude),
      'setLocation': _setLocation
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Post> posts = Provider.of<PostsProvider>(context).mapViewPosts;
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onClickMap(context);
            },
            child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    Icon(
                      Icons.map,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Select on map',
                      style: TextStyle(fontSize: 25),
                    )
                  ],
                )),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == posts.length && _loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (index < posts.length) {
                        return Column(
                          children: [PostItem(post: posts[index]), const Divider()],
                        );
                      }
                      return null;
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
