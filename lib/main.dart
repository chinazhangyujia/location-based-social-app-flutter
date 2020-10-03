import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/screen/auth_screen.dart';
import 'package:location_based_social_app/screen/new_post_screen.dart';
import 'package:location_based_social_app/screen/setting_screen.dart';
import 'package:location_based_social_app/screen/splash_screen.dart';
import 'package:location_based_social_app/screen/tab_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => AuthProvider(),),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (_) => UserProvider(),
          update: (_, auth, userProvider) => userProvider..update(auth.token)
        ),
        ChangeNotifierProxyProvider<AuthProvider, PostsProvider>(
            create: (_) => PostsProvider(),
            update: (_, auth, postsProvider) => postsProvider..update(auth.token)
        )
      ],
      child: Consumer<AuthProvider>(builder: (context, auth, _) => MaterialApp(
        title: "Lighthouse",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
        ),
        home: auth.isAuth ? 
          TabScreen() : 
          FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, authResSnapshot)
              => authResSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen()),
        routes: {
          NewPostScreen.router: (context) => NewPostScreen(),
          SettingScreen.router: (context) => SettingScreen()
        },
      ),)
    );
  }
}

