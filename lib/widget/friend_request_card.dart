import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:provider/provider.dart';

class FriendRequestCard extends StatelessWidget {
  final User fromUser;
  final String requestId;

  FriendRequestCard(this.fromUser, this.requestId);

  Future<void> onHandleRequest(BuildContext context, String status, String requestId) async {
    try {
      await Provider.of<FriendRequestProvider>(context, listen: false).handleRequest(
          status, requestId);

      await Provider.of<FriendsProvider>(context, listen: false).getAllFriends();
    } catch (error) {
      renderErrorDialog(context, 'Failed to handle friend request. Please try later');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(fromUser.avatarUrl),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(fromUser.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                Row(
                  children: [
                    ButtonTheme(
                      height: 30,
                      minWidth: 100,
                      child: RaisedButton(
                        onPressed: () {
                          onHandleRequest(context, 'accepted', requestId);
                        },
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          width: 100,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).accentColor,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Text('Accept', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    ButtonTheme(
                      height: 30,
                      minWidth: 100,
                      child: RaisedButton(
                        onPressed: () {
                          onHandleRequest(context, 'denied', requestId);
                        },
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        textColor: Colors.black,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          width: 100,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromRGBO(244, 244, 244, 1)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Text('Deny', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
