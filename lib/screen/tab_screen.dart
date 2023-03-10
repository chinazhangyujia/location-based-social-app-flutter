import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/notifications_provider.dart';
import 'package:location_based_social_app/screen/chat/chat_threads_screen.dart';
import 'package:location_based_social_app/screen/post_list/friend_posts_screen.dart';
import 'package:location_based_social_app/screen/friend/friend_request_screen.dart';
import 'package:location_based_social_app/screen/friend/friend_screen.dart';
import 'package:location_based_social_app/screen/post_list/location_based_posts_screen.dart';
import 'package:location_based_social_app/screen/profile/profile_screen.dart';
import 'package:location_based_social_app/screen/friend/search_friend_screen.dart';
import 'package:location_based_social_app/screen/notification/notification_tab_screen.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:provider/provider.dart';

/// Tab screen for this app
/// The entry point for other pages such as post list, friend, chat, profile...
class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, Object>> pages;
  int selectedPageIndex;
  int selectedSubPageIndex;

  TabController _subPageTabController;

  @override
  void initState() {
    _subPageTabController = TabController(length: 2, vsync: this);

    pages = [
      {
        'title': TabScreenConstant.LIFE_ELSEWHERE,
        'page': LocationBasedPostsScreen(),
        'subpage': [
          {
            'tabName': TabScreenConstant.LOCATION_BASED,
            'page': LocationBasedPostsScreen(),
          },
          {'tabName': TabScreenConstant.FRIENDS, 'page': FriendPostsScreen()},
        ],
        'controller': _subPageTabController
      },
      {
        'title': TabScreenConstant.FRIENDS,
        'page': FriendScreen(),
        'subpage': [],
      },
      {
        'title': TabScreenConstant.CHATS,
        'page': ChatThreadsScreen(),
        'subpage': [],
      },
      {
        'title': TabScreenConstant.PROFILE,
        'page': ProfileScreen(),
        'subpage': [],
      }
    ];

    selectedPageIndex = 0;
    selectedSubPageIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    _subPageTabController.dispose();
    super.dispose();
  }

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int unnotifiedFriendRequestCount =
        Provider.of<FriendRequestProvider>(context).unnotifiedRequests.length;
    final int unnotifiedNotificationsCount =
        Provider.of<NotificationsProvider>(context)
            .unnotifiedNotificationsCount;

    List<Widget> appBarActions;
    if (pages[selectedPageIndex]['title'] == TabScreenConstant.FRIENDS) {
      appBarActions = [
        IconButton(
          icon: unnotifiedFriendRequestCount > 0
              ? Badge(
                  position: BadgePosition.topEnd(top: -10, end: -10),
                  badgeContent: Text(
                    unnotifiedFriendRequestCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.notifications),
                )
              : const Icon(Icons.notifications),
          onPressed: () {
            Navigator.of(context).pushNamed(FriendRequestScreen.router);
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).pushNamed(SearchFriendScreen.router);
          },
        )
      ];
    } else if (pages[selectedPageIndex]['title'] == TabScreenConstant.LIFE_ELSEWHERE) {
      appBarActions = [
        IconButton(
          icon: unnotifiedNotificationsCount > 0
              ? Badge(
                  position: BadgePosition.topEnd(top: -10, end: -10),
                  badgeContent: Text(
                    unnotifiedNotificationsCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.notifications),
                )
              : const Icon(Icons.notifications),
          onPressed: () {
            Navigator.of(context).pushNamed(NotificationTabScreen.router);
          },
        ),
      ];
    }

    List<Widget> subpageComponents = [
      TabBarView(
        controller: pages[0]['controller'] as TabController,
        children: (pages[0]['subpage'] as List)
            .map((e) => e['page'] as Widget)
            .toList(),
      ),
      pages[1]['page'] as Widget,
      pages[2]['page'] as Widget,
      pages[3]['page'] as Widget,
    ];

    return DefaultTabController(
      length: (pages[selectedPageIndex]['subpage'] as List).length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          title: Text(pages[selectedPageIndex]['title'] as String),
          actions: appBarActions,
          bottom: (pages[selectedPageIndex]['subpage'] as List).isNotEmpty
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      controller: pages[selectedPageIndex]['controller']
                          as TabController,
                      tabs: (pages[selectedPageIndex]['subpage'] as List)
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                e['tabName'] as String,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : null,
        ),
        body: IndexedStack(
          index: selectedPageIndex,
          children: subpageComponents,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: selectPage,
          unselectedItemColor: Colors.black,
          selectedItemColor: Theme.of(context).accentColor,
          backgroundColor: Theme.of(context).primaryColor,
          currentIndex: selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: TabScreenConstant.BOTTOM_NAV_LABEL_HOME),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: TabScreenConstant.BOTTOM_NAV_LABEL_FRIENDS),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline), label: TabScreenConstant.BOTTOM_NAV_LABEL_CHATS),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: TabScreenConstant.BOTTOM_NAV_LABEL_PROFILE)
          ],
        ),
      ),
    );
  }
}
