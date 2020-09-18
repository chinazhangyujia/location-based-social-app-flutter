import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/user.dart';

class UserInfoCard extends StatelessWidget {

  final User user;

  UserInfoCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                SizedBox(width: 15,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 7,),
                    Text(DateFormat("MMM dd, yyyy").format(user.birthday))
                  ],
                )
              ],
            ),
          ),
          if (user.introduction != null) Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              user.introduction,
              maxLines: null,
              style: TextStyle(fontSize: 17),
            ),
          )
        ],
      ),
    );
  }
}
