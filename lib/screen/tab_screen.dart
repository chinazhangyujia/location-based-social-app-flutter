import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/screen/friend_posts_screen.dart';
import 'package:location_based_social_app/screen/friend_request_screen.dart';
import 'package:location_based_social_app/screen/friend_screen.dart';
import 'package:location_based_social_app/screen/map_screen.dart';
import 'package:location_based_social_app/screen/notification_screen.dart';
import 'package:location_based_social_app/screen/post_home_screen.dart';
import 'package:location_based_social_app/screen/profile_screen.dart';
import 'package:location_based_social_app/screen/search_friend_screen.dart';
import 'package:location_based_social_app/screen/unnotified_comments_screen.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> pages;
  int selectedPageIndex;

  @override
  void initState() {
    pages = [
      {
        'title' : 'Plot of Beach',
        'page' : PostHomeScreen()
      },
      {
        'title': 'Friends',
        'page': FriendScreen()
      },
      {
        'title' : 'Moments',
        'page' : FriendPostsScreen()
      },
      {
        'title' : 'Profile',
        'page' : ProfileScreen()
      }
    ];

    selectedPageIndex = 0;
    super.initState();
  }

  void selectPage(int index)
  {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int unnotifiedFriendRequestCount = Provider.of<FriendRequestProvider>(context).unnotifiedRequests.length;
    int unnotifiedCommentsCount = Provider.of<PostsProvider>(context).postsWithUnnotifiedComment.length;

    List<Widget> appBarActions = null;
    if (pages[selectedPageIndex]['title'] == 'Friends') {
      appBarActions = [
        IconButton(
          icon: unnotifiedFriendRequestCount > 0 ? Badge(
            position: BadgePosition.topEnd(top: -10, end: -10),
            badgeContent: Text(
              unnotifiedFriendRequestCount.toString(),
              style: TextStyle(color: Colors.white),
            ),
            child: Icon(Icons.notifications),
          ) : Icon(Icons.notifications),
          onPressed: () {
            Navigator.of(context).pushNamed(FriendRequestScreen.router);
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).pushNamed(SearchFriendScreen.router);
          },
        )
      ];
    } else if (pages[selectedPageIndex]['title'] == 'Moments') {
      appBarActions = [
        IconButton(
          icon: unnotifiedCommentsCount > 0 ? Badge(
            position: BadgePosition.topEnd(top: -10, end: -10),
            badgeContent: Text(
              unnotifiedCommentsCount.toString(),
              style: TextStyle(color: Colors.white),
            ),
            child: Icon(Icons.notifications),
          ) : Icon(Icons.notifications),
          onPressed: () {
            Navigator.of(context).pushNamed(UnnotifiedCommentsScreen.router);
          },
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(pages[selectedPageIndex]['title']),
        actions: appBarActions,
      ),
      body: pages[selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        unselectedItemColor: Colors.black,
        selectedItemColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('home')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('friends')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            title: Text('moments')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('profile')
          )
        ],
      ),
    );
  }
}
