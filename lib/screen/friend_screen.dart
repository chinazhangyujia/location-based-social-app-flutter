import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:provider/provider.dart';

class FriendScreen extends StatefulWidget {

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {

  @override
  void initState() {
    onRefresh();

    super.initState();
  }

  Future<void> onRefresh() async {
    try {
      Provider.of<FriendRequestProvider>(context, listen: false).fetchPendingRequests();
      Provider.of<FriendsProvider>(context, listen: false).getAllFriends();
    } catch (error) {
    }
  }

  Future<void> cancelFriendship(BuildContext context, String friendUserId) async {
    try {
      await Provider.of<FriendsProvider>(context, listen: false).cancelFriendship(friendUserId);
    } catch(error) {
      renderErrorDialog(context, 'Failed to delete friend. Please try later');
    }
  }

  @override
  Widget build(BuildContext context) {

    List<User> friends = Provider.of<FriendsProvider>(context).friends;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) => Column(
              children: [
                Slidable(
                  key: ValueKey(friends[index].id),
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        cancelFriendship(context, friends[index].id);
                      },
                    ),
                  ],
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(friends[index].avatarUrl),
                    ),
                    title: Text(friends[index].name, style: TextStyle(fontSize: 18,),),
                    subtitle: Text(''),
                  ),
                ),
                Divider(indent: 50,)
              ],
            )
          ),
        ),
      ),
    );
  }
}
