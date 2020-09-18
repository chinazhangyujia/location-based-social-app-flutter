import 'package:flutter/material.dart';
import 'package:location_based_social_app/screen/post_home_screen.dart';
import 'package:location_based_social_app/screen/tab_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lighthouse",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.yellowAccent,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
      ),
      home: TabScreen()
    );
  }
}

