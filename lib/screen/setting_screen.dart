import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  static const String router = '/SettingScreen';

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 0.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 40,
                    child: Row(
                      children: [
                        Text('Unique Name', style: TextStyle(fontSize: 16,),),
                        Spacer(),
                        Text(userProvider.uniqueName, style: TextStyle(fontSize: 16, color: Colors.black38))
                      ],
                    )
                  ),
                  Divider(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 40,
                    child: Row(
                      children: [
                        Text('Email', style: TextStyle(fontSize: 16,)),
                        Spacer(),
                        Text(userProvider.email, style: TextStyle(fontSize: 16, color: Colors.black38))
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Card(
            elevation: 0.5,
            child: InkWell(
              child: Container(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text('Log Out',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              onTap: () {
                authProvider.logout();
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
