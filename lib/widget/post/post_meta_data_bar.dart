import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/screen/post_list/post_location_map_view_screen.dart';
import 'package:provider/provider.dart';

/// the bar on the bottom of each post. Used for like, map... icons
class PostMetaDataBar extends StatelessWidget {
  final int likesCount;
  final bool userLiked;
  final Post post;
  final bool linkToMap;

  const PostMetaDataBar(
      {@required this.likesCount,
      @required this.userLiked,
      @required this.post,
      @required this.linkToMap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Provider.of<PostsProvider>(context, listen: false)
                      .likePost(post.id, !userLiked);
                },
                child: userLiked
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border,
                      ),
              ),
              const SizedBox(
                width: 5,
              ),
              if (likesCount > 0)
                Text(
                  '$likesCount likes',
                  style: const TextStyle(fontSize: 18),
                ),
              const SizedBox(
                width: 10,
              ),
              if (linkToMap)
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        PostLocationMapViewScreen.router,
                        arguments: post.postLocation);
                  },
                  child: const Icon(Icons.location_pin),
                )
            ],
          )
        ],
      ),
    );
  }
}
