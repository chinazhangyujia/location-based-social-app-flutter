import 'package:flutter/material.dart';
import 'package:location_based_social_app/dummy_data/dummy_data.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/screen/setting_screen.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/widget/follow_status_card.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:location_based_social_app/widget/user_info_card.dart';
import 'package:provider/provider.dart';

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
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setting', style: TextStyle(fontSize: 20),),
              trailing: IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () async {
                  try {
                    await Provider.of<UserProvider>(context, listen: false).getCurrentUser();
                  } catch(error) {
                    renderErrorDialog(context, 'Failed to get user info. Please try later.');
                    return;
                  }
                  Navigator.of(context).pushNamed(SettingScreen.router);
                },
              ),
              dense: true,
            ),
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
