import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/screen/friend_screen.dart';
import 'package:location_based_social_app/screen/map_screen.dart';
import 'package:location_based_social_app/screen/notification_screen.dart';
import 'package:location_based_social_app/screen/post_home_screen.dart';
import 'package:location_based_social_app/screen/profile_screen.dart';
import 'package:location_based_social_app/screen/search_friend_screen.dart';
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
        'title' : 'Lighthouse',
        'page' : PostHomeScreen()
      },
      {
        'title': 'Friends',
        'page': FriendScreen()
      },
      {
        'title' : 'Navigation',
        'page' : MapScreen()
      },
      {
        'title': 'Notification',
        'page': NotificationScreen()
      },
      {
        'title' : 'Profile',
        'page' : ProfileScreen()
      }
    ];

    selectedPageIndex = 0;
    super.initState();
  }

  void onClickFriendNotification(List<String> unnotifiedRequestIds) {
    Provider.of<FriendRequestProvider>(context, listen: false).markRequestsAsNotified(unnotifiedRequestIds);
  }

  void selectPage(int index)
  {
    if (index == 1) {
      try {
        Provider.of<FriendRequestProvider>(context, listen: false).fetchUnnotifiedRequest();
      } catch (error) {
      }
    }

    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> unnotifiedRequestIds = Provider.of<FriendRequestProvider>(context).unnotifiedFriendRequests.map((e) => e.id).toList();
    int unnotifiedRequestsCount = unnotifiedRequestIds.length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(pages[selectedPageIndex]['title']),
        actions: pages[selectedPageIndex]['title'] == 'Friends' ? [
          IconButton(
            icon: unnotifiedRequestsCount > 0 ? Badge(
              position: BadgePosition.topEnd(top: -10, end: -10),
              badgeContent: Text(
                unnotifiedRequestsCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(Icons.notifications),
            ) : Icon(Icons.notifications),
            onPressed: () {
              if (unnotifiedRequestsCount > 0) {
                onClickFriendNotification(unnotifiedRequestIds);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchFriendScreen.router);
            },
          )
        ] : null,
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
            icon: Icon(Icons.map),
            title: Text('map')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('Notification')
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
