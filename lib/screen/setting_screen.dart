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
        title: const Text('Settings'),
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
                        const Text('Unique Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        const Spacer(),
                        Text(userProvider.uniqueName, style: const TextStyle(fontSize: 16, color: Colors.black38))
                      ],
                    )
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 40,
                    child: Row(
                      children: [
                        const Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Text(userProvider.email, style: const TextStyle(fontSize: 16, color: Colors.black38))
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Card(
            elevation: 0.5,
            child: InkWell(
              onTap: () {
                authProvider.logout();
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                child: const Center(
                  child: Text('Log Out',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
