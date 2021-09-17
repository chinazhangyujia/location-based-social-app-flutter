import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:location_based_social_app/widget/post/post_item.dart';
import 'package:provider/provider.dart';

/// Screen to show all posts that liked by current user
class LikedPostsScreen extends StatefulWidget {
  static const String router = '/LikedPostsScreen';

  @override
  _LikedPostsScreenState createState() => _LikedPostsScreenState();
}

class _LikedPostsScreenState extends State<LikedPostsScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _pageLoading = false;
  bool _scrollAppendLoading = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (!_scrollAppendLoading &&
          _scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels) {
        setState(() {
          _scrollAppendLoading = true;
        });

        Provider.of<PostsProvider>(context, listen: false)
            .fetchLikedPosts(refresh: false)
            .then((_) {
          setState(() {
            _scrollAppendLoading = false;
          });
        });
      }
    });

    fetchPosts();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchPosts() async {
    try {
      setState(() {
        _pageLoading = true;
      });
      await Provider.of<PostsProvider>(context, listen: false)
          .fetchLikedPosts(refresh: true);
      setState(() {
        _pageLoading = false;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    final PostsProvider postsProvider = Provider.of<PostsProvider>(context);
    final List<Post> posts = postsProvider.likedPosts;

    return Scaffold(
        appBar: AppBar(
          title: const Text(LikedPostsScreenConstant.TITLE),
          elevation: 0.5,
        ),
        body: _pageLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor),
              )
            : RefreshIndicator(
                onRefresh: fetchPosts,
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
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
                              PostItem(
                                post: posts[index],
                                linkToMap: true,
                              ),
                              const Divider()
                            ],
                          );
                        }
                        return null;
                      }),
                ),
              ));
  }
}
