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

  @override
  void initState() {
    fetchPosts();

    super.initState();
  }

  Future<void> fetchPosts() async {
    try {
      Provider.of<PostsProvider>(context, listen: false).fetchFriendPosts();
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
            itemCount: posts.length,
            itemBuilder: (context, index) => Column(
              children: [
                PostItem(post: posts[index], linkToMap: true,),
                Divider()
              ],
            )
        ),
      )
    );
  }
}
