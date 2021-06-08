import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostHeader extends StatelessWidget {
  final String userAvatarUrl;
  final String userName;
  final DateTime postTimeStamp;

  const PostHeader({@required this.userAvatarUrl, @required this.userName, @required this.postTimeStamp});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // ignore: avoid_redundant_argument_values
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: userAvatarUrl,
          placeholder: (context, url) => Center(
            child: Container(
              height: 20,
              width: 20,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
      ),
      title: Text(userName,
          style: const TextStyle(
            fontSize: 18,
          )),
      subtitle: Text(
        DateFormat("MMM dd, yyyy hh:mm").format(postTimeStamp),
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
