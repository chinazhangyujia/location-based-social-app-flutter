import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/chat_thread_summary.dart';

class ChatThreadSummaryItem extends StatelessWidget {
  final ChatThreadSummary chatThreadSummary;

  const ChatThreadSummaryItem(this.chatThreadSummary);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(chatThreadSummary.chatWith.avatarUrl),
          ),
          const SizedBox(width: 15,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(chatThreadSummary.chatWith.name,
                      style: const TextStyle(fontSize: 19),
                    ),
                    const Spacer(),
                    Text(DateFormat("MMM dd, yyyy hh:mm").format(chatThreadSummary.lastMessageSentAt),
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    )
                  ],
                ),
                const SizedBox(height: 5,),
                Text(chatThreadSummary.lastMessage,
                  style: const TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
