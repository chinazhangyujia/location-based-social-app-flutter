import 'package:flutter/material.dart';

class FollowStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {},
            child: Column(
              children: [
                Text('6', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                Text('Following', style: TextStyle(fontSize: 15),)
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Column(
              children: [
                Text('10', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                Text('Follower', style: TextStyle(fontSize: 15),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
