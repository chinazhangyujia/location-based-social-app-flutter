import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'package:location_based_social_app/model/location_point.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/notifications_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/screen/create_post/new_post_screen.dart';
import 'package:location_based_social_app/screen/post_list/pick_location_map_screen.dart';
import 'package:location_based_social_app/widget/post/location_type_options.dart';
import 'package:location_based_social_app/widget/post/post_item.dart';
import 'package:provider/provider.dart';

LocationPoint selectedLocation;

/// location based posts
class LocationBasedPostsScreen extends StatefulWidget {
  @override
  _LocationBasedPostsScreenState createState() =>
      _LocationBasedPostsScreenState();
}

class _LocationBasedPostsScreenState extends State<LocationBasedPostsScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  bool _pageLoading = false;
  bool _scrollAppendLoading = false;
  bool _isInit = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _getUserLocation().then((currentLocation) {
        selectedLocation ??= currentLocation;
        final postsProvider =
            Provider.of<PostsProvider>(context, listen: false);

        _scrollController.addListener(() {
          if (!_scrollAppendLoading &&
              _scrollController.position.maxScrollExtent ==
                  _scrollController.position.pixels &&
              _scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse) {
            setState(() {
              _scrollAppendLoading = true;
            });

            appendPosts().then((_) {
              setState(() {
                _scrollAppendLoading = false;
              });
            });
          }
        });

        try {
          Provider.of<NotificationsProvider>(context, listen: false)
              .getAllNotifications();

          refreshAllPosts();
        } catch (error) {}
      });

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<LocationPoint> _getUserLocation() async {
    final Location locationTracker = Location();
    final LocationData currentLocation = await locationTracker.getLocation();
    return LocationPoint(currentLocation.longitude, currentLocation.latitude);
  }

  Future<void> refreshAllPosts() async {
    try {
      setState(() {
        _pageLoading = true;
      });
      await Provider.of<PostsProvider>(context, listen: false).fetchPosts(
        refresh: true,
        location: selectedLocation,
      );
      setState(() {
        _pageLoading = false;
      });
    } catch (error) {}
  }

  Future<void> appendPosts() async {
    try {
      Provider.of<PostsProvider>(context, listen: false).fetchPosts(
        refresh: false,
        location: selectedLocation,
      );
    } catch (error) {}
  }

  void onClickLocationTypeOption(String type) async {
    if (type == 'nearby') {
      final LocationPoint userLocation = await _getUserLocation();
      selectedLocation = userLocation;
      refreshAllPosts();
    } else if (type == 'map') {
      selectedLocation ??= await _getUserLocation();
      Navigator.of(context).pushNamed(PickLocationMapScreen.router, arguments: {
        'initialLocation': selectedLocation,
        'setLocation': (LocationPoint locationPoint) {
          selectedLocation = locationPoint;
          refreshAllPosts();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Post> posts =
        Provider.of<PostsProvider>(context).locationBasedPosts;

    return Stack(
      children: [
        Scaffold(
          body: _pageLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).accentColor),
                )
              : RefreshIndicator(
                  onRefresh: refreshAllPosts,
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: posts.length + 1,
                        itemBuilder: (context, index) {
                          if (index == posts.length && _scrollAppendLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: Theme.of(context).accentColor),
                            );
                          } else if (index < posts.length) {
                            return Column(
                              children: [
                                PostItem(post: posts[index]),
                                const Divider()
                              ],
                            );
                          }
                          return null;
                        }),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Navigator.of(context).pushNamed(NewPostScreen.router);
            },
            child: const Icon(Icons.add),
          ),
        ),
        Align(
          alignment: const Alignment(0.7, -0.95),
          child: LocationTypeOptions(
            onClickOption: onClickLocationTypeOption,
          ),
        )
      ],
    );
  }
}
