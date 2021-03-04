import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/chat_provider.dart';
import 'package:location_based_social_app/provider/comments_provider.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/provider/friends_provider.dart';
import 'package:location_based_social_app/provider/notifications_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/screen/auth_steps/auth_steps_screen.dart';
import 'package:location_based_social_app/screen/chat_screen.dart';
import 'package:location_based_social_app/screen/edit_self_introduction_screen.dart';
import 'package:location_based_social_app/screen/friend_request_screen.dart';
import 'package:location_based_social_app/screen/image_detail_screen.dart';
import 'package:location_based_social_app/screen/liked_posts_screen.dart';
import 'package:location_based_social_app/screen/my_posts_screen.dart';
import 'package:location_based_social_app/screen/new_post_screen.dart';
import 'package:location_based_social_app/screen/post_detail_screen.dart';
import 'package:location_based_social_app/screen/post_location_map_view_screen.dart';
import 'package:location_based_social_app/screen/search_friend_screen.dart';
import 'package:location_based_social_app/screen/setting_screen.dart';
import 'package:location_based_social_app/screen/splash_screen.dart';
import 'package:location_based_social_app/screen/tab_screen.dart';
import 'package:location_based_social_app/screen/notification_tab_screen.dart';
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
        ),
        ChangeNotifierProxyProvider<AuthProvider, NotificationsProvider>(
            create: (_) => NotificationsProvider(),
            update: (_, auth, notificationsProvider) => notificationsProvider..update(auth.token)
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
            create: (_) => ChatProvider(),
            update: (_, auth, chatProvider) => chatProvider..update(auth.token)
        ),
      ],
      child: Consumer<AuthProvider>(builder: (context, auth, _) => MaterialApp(
        title: "PlotOfBeach",
        theme: ThemeData(
          primarySwatch: const MaterialColor(0xFFFFFEE5,
            const <int, Color>{
              50: const Color(0xFFFFFEE5),
              100: const Color(0xFFFFFEE5),
              200: const Color(0xFFFFFEE5),
              300: const Color(0xFFFFFEE5),
              400: const Color(0xFFFFFEE5),
              500: const Color(0xFFFFFEE5),
              600: const Color(0xFFFFFEE5),
              700: const Color(0xFFFFFEE5),
              800: const Color(0xFFFFFEE5),
              900: const Color(0xFFFFFEE5),
            },),
          accentColor: Color.fromRGBO(66, 103, 178, 1),
          fontFamily: 'OpenSans',
          primaryTextTheme: TextTheme(
            headline6: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 23),
          )
        ),
        home: auth.isAuth ? 
          TabScreen() : 
          FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, authResSnapshot)
              => authResSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthStepsScreen()),
        routes: {
          NewPostScreen.router: (context) => NewPostScreen(),
          SettingScreen.router: (context) => SettingScreen(),
          PostDetailScreen.router: (context) => PostDetailScreen(),
          EditSelfIntroductionScreen.router: (context) => EditSelfIntroductionScreen(),
          SearchFriendScreen.router: (context) => SearchFriendScreen(),
          FriendRequestScreen.router: (context) => FriendRequestScreen(),
          PostLocationMapViewScreen.router: (context) => PostLocationMapViewScreen(),
          NotificationTabScreen.router: (context) => NotificationTabScreen(),
          MyPostsScreen.router: (context) => MyPostsScreen(),
          LikedPostsScreen.router: (context) => LikedPostsScreen(),
          ChatScreen.router: (context) => ChatScreen(),
          ImageDetailScreen.router: (context) => ImageDetailScreen(),
        },
      ),)
    );
  }
}

