import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class PostText extends StatelessWidget {

  final String postText;

  PostText(this.postText);

  @override
  Widget build(BuildContext context) {
    bool shouldCollapse = postText.length > 300;
    
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: ExpandableNotifier(
        child: Expandable(
          collapsed: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  postText, softWrap: true,
                  maxLines: shouldCollapse ? 5 : null,
                  style: TextStyle(
                    fontSize: 17
                  ),
                ),
                if (shouldCollapse) ExpandableButton(
                  child: Text(
                    'Show More',
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                )
              ],
            ),
          ),
          expanded: Text(
            postText,
            softWrap: true,
            style: TextStyle(
              fontSize: 17
            ),
          ),
        ),
      ),
    );
  }
}
