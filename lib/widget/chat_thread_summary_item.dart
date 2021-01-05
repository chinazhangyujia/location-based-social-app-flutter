import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/chat_thread_summary.dart';

class ChatThreadSummaryItem extends StatelessWidget {
  final ChatThreadSummary chatThreadSummary;

  ChatThreadSummaryItem(this.chatThreadSummary);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(chatThreadSummary.chatWith.avatarUrl),
          ),
          SizedBox(width: 15,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(chatThreadSummary.chatWith.name,
                      style: TextStyle(fontSize: 19),
                    ),
                    Spacer(),
                    Text(DateFormat("MMM dd, yyyy hh:mm").format(chatThreadSummary.lastMessageSentAt),
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    )
                  ],
                ),
                SizedBox(height: 5,),
                Text(chatThreadSummary.lastMessage,
                  style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
