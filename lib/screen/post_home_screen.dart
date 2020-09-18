import 'package:flutter/material.dart';
import 'package:location_based_social_app/dummy_data/dummy_data.dart';
import 'package:location_based_social_app/widget/post_item.dart';

class PostHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PostItem(
            DUMMY_POST[0]
          )
        ],
      )
    );
  }
}
