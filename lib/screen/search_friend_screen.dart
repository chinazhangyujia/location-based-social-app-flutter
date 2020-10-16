import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/user.dart';
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
        padding: const EdgeInsets.only(top: 8.0),
        child: AddFriendUserCard(foundUser),
      ),
    );
  }
}
