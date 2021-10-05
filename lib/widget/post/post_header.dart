import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:provider/provider.dart';

class PostHeader extends StatelessWidget {
  final String userId;
  final String userAvatarUrl;
  final String userName;
  final DateTime postTimeStamp;

  const PostHeader({@required this.userId, @required this.userAvatarUrl, @required this.userName, @required this.postTimeStamp});

  void _showBottomModel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: double.infinity,
        height: 150,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Provider.of<UserProvider>(context, listen: false).blockUserPost(userId);
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                child: const Text(PostHeaderConstant.BLOCK_AND_REPORT,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: 8.0,
              color: Colors.white
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                height: 70,
                child: const Text(PostHeaderConstant.CANCEL,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final User loginUser = Provider.of<UserProvider>(context).loginUser;

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
      trailing: loginUser.id != userId ? GestureDetector(
        onTap: () {
          _showBottomModel(context);
        },
        child: const Icon(Icons.more_vert)
      ) : null,
    );
  }
}
