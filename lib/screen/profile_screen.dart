import 'package:flutter/material.dart';
import 'package:location_based_social_app/dummy_data/dummy_data.dart';
import 'package:location_based_social_app/widget/follow_status_card.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:location_based_social_app/widget/user_info_card.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserInfoCard(DUMMY_USER[0]),
            Divider(),
            FollowStatusCard(),
            Divider(),
            PostItem(
              DUMMY_POST[0]
            )
          ],
        ),
      )
    );
  }
}
