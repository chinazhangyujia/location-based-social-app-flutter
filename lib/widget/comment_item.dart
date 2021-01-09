import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/comment.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/screen/search_friend_screen.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final Function onClickComment;

  CommentItem({@required this.comment, @required this.onClickComment});

  Future<void> tapUserName(BuildContext context, User tappedUser) async {
    String friendStatus = await Provider.of<FriendsProvider>(context, listen: false).getFriendStatus(tappedUser.id);

    User userWithMetaData = User(id: tappedUser.id,
        name: tappedUser.name,
        avatarUrl: tappedUser.avatarUrl,
        birthday: tappedUser.birthday,
        introduction: tappedUser.introduction,
        metaData: {'friendStatus': friendStatus }
    );

    Navigator.of(context).pushNamed(SearchFriendScreen.router, arguments: userWithMetaData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment.sendFrom.avatarUrl),
          ),
          SizedBox(width: 15,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: Text(comment.sendFrom.name,
                        style: TextStyle(fontSize: 18),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        tapUserName(context, comment.sendFrom);
                      },
                    ),
                    Spacer(),
                    Text(DateFormat("MMM dd, yyyy hh:mm").format(comment.postTime),
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    )
                  ],
                ),
                SizedBox(height: 5,),
                GestureDetector(
                  child: RichText(
                    maxLines: null,
                    text: TextSpan(
                      style: TextStyle(fontSize: 19, color: Colors.black, fontWeight: FontWeight.w300),
                      children: [
                        if (comment.sendTo != null) TextSpan(
                          text: '@${comment.sendTo.name} ',
                          style: TextStyle(color: Theme.of(context).accentColor)
                        ),
                        TextSpan(
                          text: comment.content
                        )
                      ]
                    ),
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    onClickComment(comment.sendFrom);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
