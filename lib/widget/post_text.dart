import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class PostText extends StatelessWidget {

  final String postText;

  const PostText(this.postText);

  @override
  Widget build(BuildContext context) {
    final bool shouldCollapse = postText.length > 300;
    
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
                  style: const TextStyle(
                    fontSize: 18
                  ),
                ),
                if (shouldCollapse) ExpandableButton(
                  child: const Text(
                    'Show More',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
          expanded: Text(
            postText,
            softWrap: true,
            style: const TextStyle(
              fontSize: 18
            ),
          ),
        ),
      ),
    );
  }
}
