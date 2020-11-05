import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:provider/provider.dart';

class FriendPostsScreen extends StatefulWidget {

  @override
  _FriendPostsScreenState createState() => _FriendPostsScreenState();
}

class _FriendPostsScreenState extends State<FriendPostsScreen> {

  ScrollController _scrollController = ScrollController();

  bool _loading = false;

  @override
  void initState() {

    _scrollController.addListener(() {
      if (!_loading && _scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        setState(() {
          _loading = true;
        });

        Provider.of<PostsProvider>(context, listen: false).fetchFriendPosts(fetchSize: 2, refresh: false)
            .then((_) {
          setState(() {
            _loading = false;
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
      Provider.of<PostsProvider>(context, listen: false).fetchFriendPosts(fetchSize: 2, refresh: true);
      Provider.of<PostsProvider>(context, listen: false).fetchPostsWithUnnotifiedComment();
    } catch (error) {

    }
  }

  @override
  Widget build(BuildContext context) {
    PostsProvider postsProvider = Provider.of<PostsProvider>(context);
    List<Post> posts = postsProvider.friendPosts;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchPosts,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: posts.length + 1,
          itemBuilder: (context, index) {
            if (index == posts.length && _loading) {
              return Center(child: CircularProgressIndicator(),);
            } else if (index < posts.length) {
              return Column(
                children: [
                  PostItem(post: posts[index], linkToMap: true,),
                  Divider()
                ],
              );
            }
            return null;
          }
        ),
      )
    );
  }
}
