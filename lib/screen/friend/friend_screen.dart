import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/screen/friend/search_friend_screen.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:provider/provider.dart';

/// show your friends in a list
/// slide left to delete friend
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
    } catch (error) {}
  }

  Future<void> cancelFriendship(BuildContext context, String friendUserId) async {
    try {
      await Provider.of<FriendsProvider>(context, listen: false).cancelFriendship(friendUserId);
    } catch(error) {
      renderErrorDialog(context, 'Failed to delete friend. Please try later');
    }
  }

  Future<void> onClickFriend(BuildContext context, User tappedUser) async {
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

    final List<User> friends = Provider.of<FriendsProvider>(context).friends;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) => Column(
              children: [
                GestureDetector(
                  onTap: () {
                    onClickFriend(context, friends[index]);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Slidable(
                    key: ValueKey(friends[index].id),
                    actionPane: const SlidableDrawerActionPane(),
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
                      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(friends[index].avatarUrl),
                      ),
                      title: Text(friends[index].name, style: const TextStyle(fontSize: 18,),),
                      subtitle: const Text(''),
                    ),
                  ),
                ),
                const Divider(indent: 20, height: 0,)
              ],
            )
          ),
        ),
      ),
    );
  }
}
