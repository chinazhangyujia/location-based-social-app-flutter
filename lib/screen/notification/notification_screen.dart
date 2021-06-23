import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/post_notification.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/screen/friend/search_friend_screen.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {

  final List<PostNotification> notifications;

  const NotificationScreen(this.notifications);

  Future<void> tapUserName(BuildContext context, User tappedUser) async {
    final String friendStatus = await Provider.of<FriendsProvider>(context, listen: false).getFriendStatus(tappedUser.id);

    final User userWithMetaData = User(id: tappedUser.id,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(notifications[index].sendFrom.avatarUrl),
                    ),
                    const SizedBox(width: 15,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              tapUserName(context, notifications[index].sendFrom);
                            },
                            child: Text(notifications[index].sendFrom.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(notifications[index].content,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 5,),
                          Text(DateFormat("MMM dd, yyyy hh:mm").format(notifications[index].time),
                            style: const TextStyle(fontSize: 17, color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(indent: 10, height: 0,)
            ],
          )
      ),
    );
  }
}
