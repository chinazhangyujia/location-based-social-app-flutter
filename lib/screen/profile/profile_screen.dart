import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/screen/post_list/liked_posts_screen.dart';
import 'package:location_based_social_app/screen/post_list/my_posts_screen.dart';
import 'package:location_based_social_app/screen/profile/setting_screen.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:location_based_social_app/widget/profile/single_option_page_opener.dart';
import 'package:location_based_social_app/widget/profile/user_info_card.dart';
import 'package:provider/provider.dart';

/// user profile
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
    final User loginUser = Provider.of<UserProvider>(context).loginUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: loginUser == null ?
            Center(child: CircularProgressIndicator(color: Theme.of(context).accentColor),) :
        Column(
          children: [
            Card(elevation: 0.4, child: UserInfoCard(loginUser),),
            const SizedBox(height: 10,),
            Card(
              elevation: 0.4,
              child: Column(
                children: [
                  SingleOptionPageOpener(
                      icon: const Icon(Icons.favorite),
                      title: ProfileScreenConstant.FAVORITE,
                      onTap: () {
                        Navigator.of(context).pushNamed(LikedPostsScreen.router);
                      }
                  ),
                  const Divider(indent: 30, height: 10,),
                  SingleOptionPageOpener(
                      icon: const Icon(Icons.photo),
                      title: ProfileScreenConstant.MY_POST,
                      onTap: () {
                        Navigator.of(context).pushNamed(MyPostsScreen.router);
                      }
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Card(elevation: 0.4, child: SingleOptionPageOpener(
              icon: const Icon(Icons.settings),
              title: ProfileScreenConstant.SETTING,
              onTap: () {
                Navigator.of(context).pushNamed(SettingScreen.router);
              }
            ),),
          ],
        ),
      )
    );
  }
}
