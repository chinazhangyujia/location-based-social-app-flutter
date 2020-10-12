import 'package:flutter/material.dart';
import 'package:location_based_social_app/screen/map_screen.dart';
import 'package:location_based_social_app/screen/notification_screen.dart';
import 'package:location_based_social_app/screen/post_home_screen.dart';
import 'package:location_based_social_app/screen/profile_screen.dart';

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

  void selectPage(int index)
  {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(pages[selectedPageIndex]['title']),
        actions: pages[selectedPageIndex]['title'] == 'Profile' ? [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () { },
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
