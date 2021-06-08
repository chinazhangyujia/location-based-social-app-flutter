import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:provider/provider.dart';

class MyPostsScreen extends StatefulWidget {

  static const String router = '/MyPostsScreen';

  @override
  _MyPostsScreenState createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {

  final ScrollController _scrollController = ScrollController();

  bool _loading = false;

  @override
  void initState() {

    _scrollController.addListener(() {
      if (!_loading && _scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        setState(() {
          _loading = true;
        });

        Provider.of<PostsProvider>(context, listen: false).fetchMyPosts(refresh: false)
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
      Provider.of<PostsProvider>(context, listen: false).fetchMyPosts(refresh: true);
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    final PostsProvider postsProvider = Provider.of<PostsProvider>(context);
    final List<Post> posts = postsProvider.myPosts;

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Posts'),
          elevation: 0.5,
        ),
        body: RefreshIndicator(
          onRefresh: fetchPosts,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
                controller: _scrollController,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length && _loading) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else if (index < posts.length) {
                    return Column(
                      children: [
                        PostItem(post: posts[index], linkToMap: true,),
                        const Divider()
                      ],
                    );
                  }
                  return null;
                }
            ),
          ),
        )
    );
  }
}
