import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:provider/provider.dart';

class AddFriendUserCard extends StatefulWidget {

  final User user;

  AddFriendUserCard(this.user);

  @override
  _AddFriendUserCardState createState() => _AddFriendUserCardState();
}

class _AddFriendUserCardState extends State<AddFriendUserCard> {

  bool requestSent = false;

  Future<void> onAddClick(BuildContext context, String targetUserId) async {
    try {
      await Provider.of<FriendRequestProvider>(context, listen: false)
          .sendFriendRequest(targetUserId);
      setState(() {
        requestSent = true;
      });
    }
    on HttpException catch (error) {
      renderErrorDialog(context, error.message);
    }
    catch (error) {
      renderErrorDialog(context, 'Failed to send friend request. Please try later');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 80,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(widget.user.avatarUrl),
                    ),
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 7,),
                        Text(DateFormat("MMM dd, yyyy").format(widget.user.birthday))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Text('Self Introduction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 10, left: 14),
                child: widget.user.introduction != null && widget.user.introduction.trim().isNotEmpty ? Text(
                  widget.user.introduction,
                  maxLines: null,
                  style: TextStyle(fontSize: 17),
                ) :
                Text("${widget.user.name} hasn't write self introduction yet", style: TextStyle(color: Colors.grey, fontSize: 16),),
              )
            ],
          ),
        ),
        SizedBox(height: 10,),
        if (widget.user.metaData.containsKey('friendStatus') && widget.user.metaData['friendStatus'] == 'NOT_FRIEND' && !requestSent) Card(
          child: InkWell(
            onTap: () {
              onAddClick(context, widget.user.id);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              child: Text('Add',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).accentColor,
                ),
              )
            ),
          ),
        )
      ],
    );
  }
}
