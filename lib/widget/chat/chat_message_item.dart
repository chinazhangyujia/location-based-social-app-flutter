import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// my messages will be align to right
/// other's messages will be align to left
enum ChatMessageAlignment {
  start,
  end
}

/// represent a chat message in chat_screen
class ChatMessageItem extends StatelessWidget {
  final ChatMessageAlignment alignment;
  final String message;
  final DateTime sendAt;

  const ChatMessageItem({
    @required this.alignment,
    @required this.message,
    @required this.sendAt
  });

  @override
  Widget build(BuildContext context) {
    if (alignment == ChatMessageAlignment.end) {
      //This is the sent message. We'll later use data from firebase instead of index to determine the message is sent or received.
      return Column(children: <Widget>[
        Row(
          mainAxisAlignment:
          MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              width: 200.0,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromRGBO(229, 229, 229, 1), width: 1),
                  color: const Color.fromRGBO(199, 246, 171, 1),
                  borderRadius: BorderRadius.circular(8.0)),
              margin: const EdgeInsets.only(right: 10.0),
              child: Text(
                message,
                style: const TextStyle(fontSize: 17),
              ),
            )
          ], // aligns the chatitem to right end
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  DateFormat('dd MMM hh:mm').format(sendAt),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0
                  ),
                ),
              )])
      ]);
    } else {
      // This is a received message
      return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromRGBO(229, 229, 229, 1), width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 17),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                DateFormat('dd MMM hh:mm').format(sendAt),
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontStyle: FontStyle.normal),
              ),
            )
          ],
        ),
      );
    }
  }
}
