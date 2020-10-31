import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:provider/provider.dart';

class PostMetaDataBar extends StatelessWidget {
  final int likesCount;
  final bool userLiked;
  final String postId;

  PostMetaDataBar({@required this.likesCount, @required this.userLiked, @required this.postId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Row(
            children: [
              InkWell(
                child: userLiked ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border,),
                onTap: () {
                  Provider.of<PostsProvider>(context, listen: false).likePost(postId, !userLiked);
                },
              ),
              SizedBox(width: 5,),
              if (likesCount > 0) Text('${likesCount} likes', style: TextStyle(fontSize: 16),)
            ],
          )
        ],
      ),
    );
  }
}
