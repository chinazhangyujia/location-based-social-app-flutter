import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:provider/provider.dart';

class LikedPostsScreen extends StatefulWidget {

  static const String router = '/LikedPostsScreen';

  @override
  _LikedPostsScreenState createState() => _LikedPostsScreenState();
}

class _LikedPostsScreenState extends State<LikedPostsScreen> {

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

        Provider.of<PostsProvider>(context, listen: false).fetchLikedPosts(fetchSize: 2, refresh: false)
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
      Provider.of<PostsProvider>(context, listen: false).fetchLikedPosts(fetchSize: 2, refresh: true);
    } catch (error) {

    }
  }

  @override
  Widget build(BuildContext context) {
    PostsProvider postsProvider = Provider.of<PostsProvider>(context);
    List<Post> posts = postsProvider.likedPosts;

    return Scaffold(
        appBar: AppBar(
          title: Text('Liked Posts'),
          elevation: 0.5,
        ),
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
