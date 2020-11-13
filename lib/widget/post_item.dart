import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/screen/post_detail_screen.dart';
import 'package:location_based_social_app/screen/post_location_map_view_screen.dart';
import 'package:location_based_social_app/widget/post_header.dart';
import 'package:location_based_social_app/widget/post_meta_data_bar.dart';
import 'package:location_based_social_app/widget/post_text.dart';
import 'package:location_based_social_app/widget/six_photos_grid.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final bool disableClick;
  final bool linkToMap;

  PostItem({@required this.post, this.disableClick = false, this.linkToMap = false});

  void onTapPost(BuildContext context) {
    Navigator.of(context).pushNamed(PostDetailScreen.router, arguments: post);
  }

  @override
  Widget build(BuildContext context) {

    User user = post.user;

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            userAvatarUrl: user.avatarUrl,
            userName: user.name,
            postTimeStamp: post.postedTimeStamp,
          ),
          GestureDetector(
            onTap: disableClick ? null : () {
              onTapPost(context);
            },
            child: Column(
              children: [
                if (post.photoUrls.isNotEmpty) SixPhotosGrid(post.photoUrls),
                PostText(post.content),
              ],
            ),
          ),
          PostMetaDataBar(likesCount: post.likesCount, userLiked: post.userLiked, postId: post.id,),
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.of(context).pushNamed(PostLocationMapViewScreen.router, arguments: post.postLocation);
            },
            child: Text('See Location',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey
              ),
            )
          )
        ],
      ),
    );
  }
}
