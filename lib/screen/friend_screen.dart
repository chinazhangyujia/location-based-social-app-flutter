import 'package:flutter/material.dart';
import 'package:location_based_social_app/dummy_data/dummy_data.dart';
import 'package:location_based_social_app/model/user.dart';

class FriendScreen extends StatelessWidget {
  final List<User> friends = DUMMY_FRIENDS;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) => Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(friends[index].avatarUrl),
                ),
                title: Text(friends[index].name),
              ),
              Divider()
            ],
          )
        ),
      ),
    );
  }
}
