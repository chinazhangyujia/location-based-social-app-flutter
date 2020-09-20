import 'package:flutter/material.dart';

class PostMetaDataBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Row(
            children: [
              InkWell(
                child: Icon(Icons.favorite_border),
                onTap: () {},
              ),
              SizedBox(width: 5,),
              Text('6 likes', style: TextStyle(fontSize: 16),)
            ],
          )
        ],
      ),
    );
  }
}
