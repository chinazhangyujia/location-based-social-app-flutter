import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/friend_request.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/comments_provider.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/screen/auth_screen.dart';
import 'package:location_based_social_app/screen/edit_self_introduction_screen.dart';
import 'package:location_based_social_app/screen/friend_request_screen.dart';
import 'package:location_based_social_app/screen/new_post_screen.dart';
import 'package:location_based_social_app/screen/post_detail_screen.dart';
import 'package:location_based_social_app/screen/search_friend_screen.dart';
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
        ),
        ChangeNotifierProxyProvider<AuthProvider, CommentsProvider>(
          create: (_) => CommentsProvider(),
          update: (_, auth, commentsProvider) => commentsProvider..update(auth.token)
        ),
        ChangeNotifierProxyProvider<AuthProvider, FriendsProvider>(
          create: (_) => FriendsProvider(),
          update: (_, auth, friendsProvider) => friendsProvider..update(auth.token)
        ),
        ChangeNotifierProxyProvider<AuthProvider, FriendRequestProvider>(
            create: (_) => FriendRequestProvider(),
            update: (_, auth, friendRequestProvider) => friendRequestProvider..update(auth.token)
        )
      ],
      child: Consumer<AuthProvider>(builder: (context, auth, _) => MaterialApp(
        title: "PlotOfBeach",
        theme: ThemeData(
          primarySwatch: const MaterialColor(0xFFFFFFFF,
            const <int, Color>{
              50: const Color(0xFFFFFFFF),
              100: const Color(0xFFFFFFFF),
              200: const Color(0xFFFFFFFF),
              300: const Color(0xFFFFFFFF),
              400: const Color(0xFFFFFFFF),
              500: const Color(0xFFFFFFFF),
              600: const Color(0xFFFFFFFF),
              700: const Color(0xFFFFFFFF),
              800: const Color(0xFFFFFFFF),
              900: const Color(0xFFFFFFFF),
            },),
          accentColor: Colors.blueAccent,
        ),
        home: auth.isAuth ? 
          TabScreen() : 
          FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, authResSnapshot)
              => authResSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen()),
        routes: {
          NewPostScreen.router: (context) => NewPostScreen(),
          SettingScreen.router: (context) => SettingScreen(),
          PostDetailScreen.router: (context) => PostDetailScreen(),
          EditSelfIntroductionScreen.router: (context) => EditSelfIntroductionScreen(),
          SearchFriendScreen.router: (context) => SearchFriendScreen(),
          FriendRequestScreen.router: (context) => FriendRequestScreen()
        },
      ),)
    );
  }
}

