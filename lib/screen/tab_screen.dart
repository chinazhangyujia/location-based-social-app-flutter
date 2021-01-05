import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/notifications_provider.dart';
import 'package:location_based_social_app/screen/chat_threads_screen.dart';
import 'package:location_based_social_app/screen/friend_posts_screen.dart';
import 'package:location_based_social_app/screen/friend_request_screen.dart';
import 'package:location_based_social_app/screen/friend_screen.dart';
import 'package:location_based_social_app/screen/post_home_screen.dart';
import 'package:location_based_social_app/screen/profile_screen.dart';
import 'package:location_based_social_app/screen/search_friend_screen.dart';
import 'package:location_based_social_app/screen/notification_tab_screen.dart';
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
        'page' : PostHomeScreen(),
        'subpage': [
          {
            'tabName': 'Nearby',
            'page': PostHomeScreen(),
          },
          {
            'tabName': 'Friends',
            'page': FriendPostsScreen()
          }
        ]
      },
      {
        'title': 'Friends',
        'page': FriendScreen(),
        'subpage': [],
      },
      {
        'title': 'Chats',
        'page': ChatThreadsScreen(),
        'subpage': [],
      },
      {
        'title' : 'Profile',
        'page' : ProfileScreen(),
        'subpage': [],
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
    int unnotifiedNotificationsCount = Provider.of<NotificationsProvider>(context).unnotifiedNotificationsCount;

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
    } else if (pages[selectedPageIndex]['title'] == 'Plot of Beach') {
      appBarActions = [
        IconButton(
          icon: unnotifiedNotificationsCount > 0 ? Badge(
            position: BadgePosition.topEnd(top: -10, end: -10),
            badgeContent: Text(
              unnotifiedNotificationsCount.toString(),
              style: TextStyle(color: Colors.white),
            ),
            child: Icon(Icons.notifications),
          ) : Icon(Icons.notifications),
          onPressed: () {
            Navigator.of(context).pushNamed(NotificationTabScreen.router);
          },
        ),
      ];
    }

    return DefaultTabController(
      length: (pages[selectedPageIndex]['subpage'] as List).length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          title: Text(pages[selectedPageIndex]['title']),
          actions: appBarActions,
          bottom: (pages[selectedPageIndex]['subpage'] as List).isNotEmpty ? PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                tabs: (pages[selectedPageIndex]['subpage'] as List)
                    .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(e['tabName'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    ),).toList(),
              ),
            ),
          ) : null,
        ),
        body: (pages[selectedPageIndex]['subpage'] as List).isEmpty ?
          pages[selectedPageIndex]['page'] : TabBarView(
            children: (pages[selectedPageIndex]['subpage'] as List)
                .map((e) => e['page'] as Widget).toList()
          ),
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
              label: 'home'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'friends'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: 'chats'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'profile'
            )
          ],
        ),
      ),
    );
  }
}
