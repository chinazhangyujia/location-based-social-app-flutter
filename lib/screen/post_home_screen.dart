import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:location_based_social_app/model/location_point.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/notifications_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/screen/new_post_screen.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:provider/provider.dart';

class PostHomeScreen extends StatefulWidget {
  @override
  _PostHomeScreenState createState() => _PostHomeScreenState();
}

class _PostHomeScreenState extends State<PostHomeScreen> {
  LocationPoint _currentLocation;
  final ScrollController _scrollController = ScrollController();

  bool _loading = false;

  @override
  void initState() {
    _initializeLocation().then((currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
      });
      final postsProvider = Provider.of<PostsProvider>(context, listen: false);

      _scrollController.addListener(() {
        if (!_loading &&
            _scrollController.position.maxScrollExtent ==
                _scrollController.position.pixels) {
          setState(() {
            _loading = true;
          });

          postsProvider
              .fetchPosts(
                  refresh: false, location: currentLocation, isNearby: true)
              .then((_) {
            setState(() {
              _loading = false;
            });
          });
        }
      });

      try {
        Provider.of<NotificationsProvider>(context, listen: false)
            .getAllNotifications();

        postsProvider.fetchPosts(
            refresh: true, location: currentLocation, isNearby: true);
      } catch (error) {}
    });

    super.initState();
  }

  Future<LocationPoint> _initializeLocation() async {
    final Location locationTracker = Location();
    final LocationData currentLocation = await locationTracker.getLocation();
    return LocationPoint(currentLocation.longitude, currentLocation.latitude);
  }

  Future<void> onRefresh() async {
    try {
      Provider.of<PostsProvider>(context, listen: false).fetchPosts(
          refresh: true, location: _currentLocation, isNearby: true);
    } catch (error) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Post> posts = Provider.of<PostsProvider>(context).nearbyPosts;

    return Scaffold(
      body: RefreshIndicator(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(NewPostScreen.router);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
