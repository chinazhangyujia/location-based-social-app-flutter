import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/user.dart';

/**
 * represent a chat message in the chat room
 */
class ChatMessage {
  final String id;
  final String threadId; // id of the thread (chat room). Currently only support 1 v 1
  final String content;
  final User sendFrom;
  final User sendTo;
  final DateTime sendTime;

  const ChatMessage({
    @required this.id,
    @required this.threadId,
    @required this.content,
    @required this.sendFrom,
    @required this.sendTo,
    @required this.sendTime,
  });
}