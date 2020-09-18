import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class PostText extends StatelessWidget {

  final String postText;

  PostText(this.postText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ExpandableNotifier(
        child: Expandable(
          collapsed: ExpandableButton(
            child: Text(
              postText, softWrap: true,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17
              ),
            ),
          ),
          expanded: ExpandableButton(
            child: Text(
              postText,
              softWrap: true,
              style: TextStyle(
                fontSize: 17
              ),
            ),
          ),
        ),
      ),
    );
  }
}
