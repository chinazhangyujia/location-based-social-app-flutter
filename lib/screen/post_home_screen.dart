import 'package:flutter/material.dart';
import 'package:location_based_social_app/dummy_data/dummy_data.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/screen/new_post_screen.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:provider/provider.dart';

class PostHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    PostsProvider postsProvider = Provider.of<PostsProvider>(context);
    List<Post> posts = postsProvider.posts;

    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => Column(
          children: [
            PostItem(posts[index]),
            Divider()
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(NewPostScreen.router);
        },
      ),
    );
  }
}
