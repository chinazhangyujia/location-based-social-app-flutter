import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:provider/provider.dart';

class PostMetaDataBar extends StatelessWidget {
  final int likesCount;
  final bool userLiked;
  final String postId;

  const PostMetaDataBar({@required this.likesCount, @required this.userLiked, @required this.postId});

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
                  Provider.of<PostsProvider>(context, listen: false).likePost(postId, !userLiked);
                },
                child: userLiked ? const Icon(Icons.favorite, color: Colors.red,) : const Icon(Icons.favorite_border,),
              ),
              const SizedBox(width: 5,),
              if (likesCount > 0) Text('$likesCount likes', style: const TextStyle(fontSize: 16),)
            ],
          )
        ],
      ),
    );
  }
}
