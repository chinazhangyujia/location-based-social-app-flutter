import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/screen/post_detail/post_detail_screen.dart';
import 'package:location_based_social_app/screen/post_list/post_location_map_view_screen.dart';
import 'package:provider/provider.dart';

/// the bar on the bottom of each post. Used for like, map... icons
class PostMetaDataBar extends StatefulWidget {
  final int likesCount;
  final bool userLiked;
  final Post post;
  final bool linkToMap;
  final void Function()
      onClickCommentIcon; // direct to post detail if it's null

  const PostMetaDataBar(
      {@required this.likesCount,
      @required this.userLiked,
      @required this.post,
      @required this.linkToMap,
      this.onClickCommentIcon});

  @override
  _PostMetaDataBarState createState() => _PostMetaDataBarState();
}

class _PostMetaDataBarState extends State<PostMetaDataBar> {

  bool _userLiked;

  @override
  void initState() {
    super.initState();
    _userLiked = widget.userLiked;
  }

  Widget _renderLikeIcon(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Provider.of<PostsProvider>(context, listen: false)
                .likePost(widget.post.id, !_userLiked);
            setState(() {
              _userLiked = !_userLiked;
            });
          },
          child: _userLiked
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.favorite_border,
                ),
        ),
        if (widget.likesCount > 0)
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Text(
                '${widget.likesCount}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          )
      ],
    );
  }

  Widget _renderCommentIcon(BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap: () {
              if (widget.onClickCommentIcon != null) {
                widget.onClickCommentIcon();
              } else {
                _onTapCommentIcon(context);
              }  
            },
            child: const Icon(Icons.chat_bubble_outline)),
        if (widget.post.commentCount > 0)
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Text(
                '${widget.post.commentCount}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          )
      ],
    );
  }

  Widget _renderMapIcon(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 30,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(PostLocationMapViewScreen.router,
                arguments: widget.post.postLocation);
          },
          child: const Icon(Icons.location_pin),
        ),
      ],
    );
  }

  Widget _renderTopic(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: Chip(
        label: Text(widget.post.topic.displayName),
        backgroundColor: Theme.of(context).accentColor,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 19),
      ),
    );
  }

  void _onTapCommentIcon(BuildContext context) {
    Navigator.of(context).pushNamed(PostDetailScreen.router, arguments: widget.post);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          _renderLikeIcon(context),
          SizedBox(width: 30),
          _renderCommentIcon(context),
          if (widget.linkToMap) _renderMapIcon(context),
          SizedBox(
            width: 30,
          ),
          _renderTopic(context)
        ],
      ),
    );
  }
}
