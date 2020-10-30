import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:provider/provider.dart';

class UnnotifiedCommentsScreen extends StatelessWidget {

  static const String router = '/UnnotifiedCommentsScreen';

  @override
  Widget build(BuildContext context) {
    PostsProvider postsProvider = Provider.of<PostsProvider>(context, listen: false);
    List<Post> posts = postsProvider.postsWithUnnotifiedComment;

    if (posts.isNotEmpty) {
      postsProvider.markPostsAsNotified(posts.map((e) => e.id).toList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        elevation: 0.5,
      ),
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) => Column(
            children: [
              PostItem(post: posts[index], linkToMap: true,),
              Divider()
            ],
          )
      )
    );
  }
}
