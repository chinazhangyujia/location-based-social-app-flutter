import 'package:flutter/material.dart';
import 'package:location_based_social_app/screen/auth_screen.dart';
import 'package:location_based_social_app/screen/new_post_screen.dart';
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
        accentColor: Colors.amber,
      ),
      home: AuthScreen(),
      routes: {
        NewPostScreen.router: (context) => NewPostScreen()
      },
    );
  }
}

