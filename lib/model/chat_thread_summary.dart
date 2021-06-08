import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/user.dart';

/// represent one item in the chat list in chat screen
class ChatThreadSummary {
  final User chatWith;
  String lastMessage;
  final String threadId;
  DateTime lastMessageSentAt;

  ChatThreadSummary({
    @required this.chatWith,
    @required this.lastMessage,
    @required this.threadId,
    @required this.lastMessageSentAt
  });
}