import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/screen/edit_self_introduction_screen.dart';

class UserInfoCard extends StatelessWidget {

  final User user;

  UserInfoCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text('Self Introduction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(EditSelfIntroductionScreen.router);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10, left: 14),
            child: user.introduction != null && user.introduction.trim().isNotEmpty ? Text(
              user.introduction,
              maxLines: null,
              style: TextStyle(fontSize: 17),
            ) :
            Text('Write something about yourself...', style: TextStyle(color: Colors.grey, fontSize: 16),),
          )
        )
      ],
    );
  }
}
