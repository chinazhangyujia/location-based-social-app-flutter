import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/screen/post_detail/post_detail_screen.dart';
import 'package:location_based_social_app/screen/friend/search_friend_screen.dart';
import 'package:location_based_social_app/widget/post/post_header.dart';
import 'package:location_based_social_app/widget/post/post_meta_data_bar.dart';
import 'package:location_based_social_app/widget/post/post_text.dart';
import 'package:location_based_social_app/widget/post/six_photos_grid.dart';
import 'package:provider/provider.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final bool disableClick;
  final bool linkToMap;

  const PostItem({@required this.post, this.disableClick = false, this.linkToMap = false});

  Future<void> onTapHeader(BuildContext context, User tappedUser) async {
    final String friendStatus = await Provider.of<FriendsProvider>(context, listen: false).getFriendStatus(tappedUser.id);

    final User userWithMetaData = User(id: tappedUser.id,
        name: tappedUser.name,
        avatarUrl: tappedUser.avatarUrl,
        introduction: tappedUser.introduction,
        metaData: {'friendStatus': friendStatus }
    );

    Navigator.of(context).pushNamed(SearchFriendScreen.router, arguments: userWithMetaData);
  }

  void onTapPost(BuildContext context) {
    Navigator.of(context).pushNamed(PostDetailScreen.router, arguments: post);
  }

  @override
  Widget build(BuildContext context) {

    final User user = post.user;

    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onTapHeader(context, user);
            },
            child: PostHeader(
              userAvatarUrl: user.avatarUrl,
              userName: user.name,
              postTimeStamp: post.postedTimeStamp,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: disableClick ? null : () {
              onTapPost(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.photoUrls.isNotEmpty) SixPhotosGrid(post.photoUrls),
                if (post.content != null) PostText(post.content),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: PostMetaDataBar(likesCount: post.likesCount, userLiked: post.userLiked, post: post, linkToMap: linkToMap,),
          ),
        ],
      ),
    );
  }
}
