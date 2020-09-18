import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostHeader extends StatelessWidget {

  final String userAvatarUrl;
  final String userName;
  final DateTime postTimeStamp;

  PostHeader({
    @required this.userAvatarUrl,
    @required this.userName,
    @required this.postTimeStamp
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userAvatarUrl),
      ),
      title: Text(userName),
      subtitle: Text(DateFormat("MMM dd, yyyy hh:mm").format(postTimeStamp)),
    );
  }
}
