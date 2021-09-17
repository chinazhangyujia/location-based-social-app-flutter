import 'package:flutter/material.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/chat_provider.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/screen/chat/chat_screen.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/widget/friend/add_friend_user_card.dart';
import 'package:provider/provider.dart';

/// screen to search a user by unique name
class SearchFriendScreen extends StatefulWidget {
  static const String router = '/SearchFriendScreen';

  @override
  _SearchFriendScreenState createState() => _SearchFriendScreenState();
}

class _SearchFriendScreenState extends State<SearchFriendScreen> {
  TextEditingController textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  User foundUser;
  bool _isInit = true;
  bool addRequestSent = false;
  bool deleteRequestSent = false;
  String _uniqueNameHintText = SearchFriendScreenConstant.UNIQUE_NAME_HINT;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      foundUser = ModalRoute.of(context).settings.arguments as User;

      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          setState(() {
            _uniqueNameHintText = '';
          });
        } else {
          setState(() {
            _uniqueNameHintText = SearchFriendScreenConstant.UNIQUE_NAME_HINT;
          });
        }
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> onSendUniqueName(BuildContext context) async {
    try {
      final String uniqueName = textController.text;
      final User userByUniqueName =
          await Provider.of<UserProvider>(context, listen: false)
              .getUserByUniqueName(uniqueName);

      setState(() {
        foundUser = userByUniqueName;
      });
    } on HttpException catch (error) {
      renderErrorDialog(context, error.message);
    } catch (error) {
      renderErrorDialog(context, SearchFriendScreenConstant.FAILED_TO_FIND_USER_ERROR_MESSAGE);
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
    } on HttpException catch (error) {
      renderErrorDialog(context, error.message);
    } catch (error) {
      renderErrorDialog(
          context, SearchFriendScreenConstant.FAILED_TO_SEND_FRIEND_REQUEST_ERROR_MESSAGE);
    }
  }

  Future<void> goToChatScreen(BuildContext context) async {
    await Provider.of<ChatProvider>(context, listen: false)
        .connectToThread(foundUser);
    Navigator.of(context).pushNamed(ChatScreen.router, arguments: foundUser);
  }

  Future<void> onDeleteClick(BuildContext context, String friendUserId) async {
    try {
      await Provider.of<FriendsProvider>(context, listen: false)
          .cancelFriendship(friendUserId);
      setState(() {
        deleteRequestSent = true;
      });
    } catch (error) {
      renderErrorDialog(context, SearchFriendScreenConstant.FAILED_TO_DELETE_FRIEND_ERROR_MESSAGE);
    }
  }

  Widget _getBottomSheet(BuildContext context, User targetUser) {
    String text;
    void Function() onClick;
    Icon icon;
    Color color;
    const double size = 24;
    if (deleteRequestSent) {
      text = null;
      icon = null;
      color = null;
      onClick = null;
    } else if (targetUser.metaData.containsKey('friendStatus') &&
        targetUser.metaData['friendStatus'] == 'NOT_FRIEND' &&
        !addRequestSent) {
      text = 'Add';
      icon = Icon(
        Icons.add_circle_outline_sharp,
        color: Theme.of(context).accentColor,
        size: size,
      );
      color = Theme.of(context).accentColor;
      onClick = () {
        onAddClick(context, targetUser.id);
      };
    } else if (targetUser.metaData.containsKey('friendStatus') &&
        targetUser.metaData['friendStatus'] == 'IS_FRIEND') {
      text = 'Delete';
      icon = Icon(
        Icons.delete,
        color: Theme.of(context).errorColor,
        size: size,
      );
      color = Theme.of(context).errorColor;
      onClick = () {
        onDeleteClick(context, targetUser.id);
      };
    } else if (targetUser.metaData.containsKey('friendStatus') &&
            targetUser.metaData['friendStatus'] == 'NOT_FRIEND' &&
            addRequestSent ||
        targetUser.metaData.containsKey('friendStatus') &&
            targetUser.metaData['friendStatus'] == 'PENDING') {
      text = SearchFriendScreenConstant.PENDING;
      icon = Icon(
        Icons.pending,
        color: Theme.of(context).disabledColor,
        size: size,
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
        decoration:
            BoxDecoration(color: Theme.of(context).primaryColor, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ]),
        height: 90,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                goToChatScreen(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Theme.of(context).accentColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      SearchFriendScreenConstant.MESSAGE,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: onClick,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: color),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
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
        title: const Text(SearchFriendScreenConstant.SEARCH),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              alignment: Alignment.center,
              height: 37,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromRGBO(244, 244, 244, 1)),
              child: TextField(
                onSubmitted: (_) {
                  onSendUniqueName(context);
                },
                controller: textController,
                focusNode: _focusNode,
                cursorColor: Theme.of(context).accentColor,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: _uniqueNameHintText,
                ),
              ),
            ),
          ),
        ),
      ),
      body: foundUser == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: AddFriendUserCard(foundUser),
            ),
      bottomSheet:
          foundUser == null ? null : _getBottomSheet(context, foundUser),
    );
  }
}
