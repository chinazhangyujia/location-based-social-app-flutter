import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ChatMessageAlignment {
  start,
  end
}

class ChatMessageItem extends StatelessWidget {
  final ChatMessageAlignment alignment;
  final String message;
  final DateTime sendAt;

  ChatMessageItem({
    @required this.alignment,
    @required this.message,
    @required this.sendAt
  });

  @override
  Widget build(BuildContext context) {
    if (alignment == ChatMessageAlignment.end) {
      //This is the sent message. We'll later use data from firebase instead of index to determine the message is sent or received.
      return Container(
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 17),
                  ),
                  padding: EdgeInsets.all(10),
                  width: 200.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color.fromRGBO(229, 229, 229, 1), width: 1),
                      color: Color.fromRGBO(199, 246, 171, 1),
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(right: 10.0),
                )
              ],
              mainAxisAlignment:
              MainAxisAlignment.end, // aligns the chatitem to right end
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      DateFormat('dd MMM hh:mm').format(sendAt),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0
                      ),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  )])
          ]));
    } else {
      // This is a received message
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 17),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color.fromRGBO(229, 229, 229, 1), width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ],
            ),
            Container(
              child: Text(
                DateFormat('dd MMM hh:mm').format(sendAt),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontStyle: FontStyle.normal),
              ),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
}
