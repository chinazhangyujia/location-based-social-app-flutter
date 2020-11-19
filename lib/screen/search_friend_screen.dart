import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/widget/add_friend_user_card.dart';
import 'package:provider/provider.dart';

class SearchFriendScreen extends StatefulWidget {
  static const String router = '/SearchFriendScreen';

  @override
  _SearchFriendScreenState createState() => _SearchFriendScreenState();
}

class _SearchFriendScreenState extends State<SearchFriendScreen> {

  TextEditingController textController = TextEditingController();
  User foundUser;
  bool _isInit = true;
  bool addRequestSent = false;
  bool deleteRequestSent = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      foundUser = ModalRoute.of(context).settings.arguments as User;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> onSendUniqueName(BuildContext context) async {
    try {
      String uniqueName = textController.text;
      User userByUniqueName = await Provider.of<UserProvider>(context, listen: false)
          .getUserByUniqueName(uniqueName);

      setState(() {
        foundUser = userByUniqueName;
      });
    } on HttpException catch (error) {
      renderErrorDialog(context, error.message);
    } catch (error) {
      renderErrorDialog(context, 'Failed to find user. Please try later');
    }

    textController.clear();
  }

  Future<void> onAddClick(BuildContext context, String targetUserId) async {
    try {
      await Provider.of<FriendRequestProvider>(context, listen: false)
          .sendFriendRequest(targetUserId);
      setState(() {
        addRequestSent = true;
      });
    }
    on HttpException catch (error) {
      renderErrorDialog(context, error.message);
    }
    catch (error) {
      renderErrorDialog(context, 'Failed to send friend request. Please try later');
    }
  }

  Future<void> onDeleteClick(BuildContext context, String friendUserId) async {
    try {
      await Provider.of<FriendsProvider>(context, listen: false).cancelFriendship(friendUserId);
      setState(() {
        deleteRequestSent = true;
      });
    } catch(error) {
      renderErrorDialog(context, 'Failed to delete friend. Please try later');
    }
  }

  Widget _getBottomSheet(BuildContext context, User targetUser) {
    String text;
    Function onClick;
    Icon icon;
    Color color;
    if (deleteRequestSent) {
      text = null;
      icon = null;
      color = null;
      onClick = null;
    }
    else if (targetUser.metaData.containsKey('friendStatus') && targetUser.metaData['friendStatus'] == 'NOT_FRIEND' && !addRequestSent) {
      text = 'Add';
      icon = Icon(
        Icons.add_circle_outline_sharp,
        color: Theme.of(context).accentColor,
        size: 30,
      );
      color = Theme.of(context).accentColor;
      onClick = () {onAddClick(context, targetUser.id);};
    } else if (targetUser.metaData.containsKey('friendStatus') && targetUser.metaData['friendStatus'] == 'IS_FRIEND') {
      text = 'Delete';
      icon = Icon(
        Icons.delete,
        color: Theme.of(context).errorColor,
        size: 30,
      );
      color = Theme.of(context).errorColor;
      onClick = () {onDeleteClick(context, targetUser.id);};
    } else if (targetUser.metaData.containsKey('friendStatus') && targetUser.metaData['friendStatus'] == 'NOT_FRIEND' && addRequestSent ||
        targetUser.metaData.containsKey('friendStatus') && targetUser.metaData['friendStatus'] == 'PENDING'
    ) {
      text = 'Pending';
      icon = Icon(
        Icons.pending,
        color: Theme.of(context).disabledColor,
        size: 30,
      );
      color = Theme.of(context).disabledColor;
      onClick = null;
    } else {
      text = null;
      icon = null;
      color = null;
      onClick = null;
    }

    if (text == null) {
      return null;
    }

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ]
        ),
        height: 90,
        alignment: Alignment.center,
        child: InkWell(
          onTap: onClick,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: 10,),
                Text(text,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: color
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Search'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              alignment: Alignment.center,
              height: 37,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(244, 244, 244, 1)
              ),
              child: TextField(
                onSubmitted: (_) {
                  onSendUniqueName(context);
                },
                controller: textController,
                cursorColor: Theme.of(context).accentColor,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.send,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: 'Unique Name',
                ),
              ),
            ),
          ),
        ),
      ),
      body: foundUser == null ? null : Padding(
        padding: const EdgeInsets.all(8.0),
        child: AddFriendUserCard(foundUser),
      ),
      bottomSheet: foundUser == null ? null : _getBottomSheet(context, foundUser),
    );
  }
}
