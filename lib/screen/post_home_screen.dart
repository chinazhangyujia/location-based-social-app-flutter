import 'package:flutter/material.dart';
import 'package:location_based_social_app/dummy_data/dummy_data.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/widget/post_item.dart';

class PostHomeScreen extends StatelessWidget {

  List<Post> posts = DUMMY_POST;

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
