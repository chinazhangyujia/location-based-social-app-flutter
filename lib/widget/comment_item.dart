import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/comment.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final Function onClickComment;

  CommentItem({@required this.comment, @required this.onClickComment});

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
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      onTap: () {

                      },
                    ),
                    Spacer(),
                    Text(DateFormat("MMM dd, yyyy hh:mm").format(comment.postTime),
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    )
                  ],
                ),
                SizedBox(height: 5,),
                GestureDetector(
                  child: RichText(
                    maxLines: null,
                    text: TextSpan(
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
