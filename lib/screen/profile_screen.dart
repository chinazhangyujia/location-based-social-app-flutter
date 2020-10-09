import 'package:flutter/material.dart';
import 'package:location_based_social_app/dummy_data/dummy_data.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/screen/setting_screen.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/widget/follow_status_card.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:location_based_social_app/widget/single_option_page_opener.dart';
import 'package:location_based_social_app/widget/user_info_card.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User loginUser = Provider.of<UserProvider>(context).loginUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: loginUser == null ?
            Center(child: CircularProgressIndicator(),) :
        Column(
          children: [
            Card(child: UserInfoCard(loginUser), elevation: 0.4,),
            SizedBox(height: 10,),
            Card(
              child: Column(
                children: [
                  SingleOptionPageOpener(
                      icon: Icon(Icons.favorite),
                      title: 'Favorite',
                      onTap: () {

                      }
                  ),
                  Divider(indent: 30, height: 10,),
                  SingleOptionPageOpener(
                      icon: Icon(Icons.photo),
                      title: 'My Post',
                      onTap: () {

                      }
                  )
                ],
              ),
              elevation: 0.4,
            ),
            SizedBox(height: 10,),
            Card(child: SingleOptionPageOpener(
              icon: Icon(Icons.settings),
              title: 'Setting',
              onTap: () {
                Navigator.of(context).pushNamed(SettingScreen.router);
              }
            ), elevation: 0.4,),
          ],
        ),
      )
    );
  }
}
