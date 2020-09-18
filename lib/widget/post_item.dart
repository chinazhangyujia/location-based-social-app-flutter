import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/widget/post_header.dart';
import 'package:location_based_social_app/widget/post_text.dart';
import 'package:location_based_social_app/widget/six_photos_grid.dart';

class PostItem extends StatelessWidget {
  final Post post;

  PostItem(this.post);

  @override
  Widget build(BuildContext context) {

    User user = post.user;

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          PostHeader(
            userAvatarUrl: user.avatarUrl,
            userName: user.name,
            postTimeStamp: post.postedTimeStamp,
          ),
          SixPhotosGrid(post.photoUrls),
          PostText(post.content)
        ],
      ),
    );
  }
}
