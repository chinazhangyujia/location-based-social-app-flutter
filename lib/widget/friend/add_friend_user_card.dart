import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/user.dart';

/// The widget to show a user's general information after searching user
class AddFriendUserCard extends StatelessWidget {

  final User user;

  const AddFriendUserCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              const SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 7,),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        const Padding(
          padding: EdgeInsets.only(left: 14),
          child: Text('Self Introduction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10, left: 14),
          child: user.introduction != null && user.introduction.trim().isNotEmpty ? Text(
            user.introduction,
            style: const TextStyle(fontSize: 17),
          ) :
          Text("${user.name} hasn't write self introduction yet", style: const TextStyle(color: Colors.grey, fontSize: 16),),
        )
      ],
    );
  }
}
