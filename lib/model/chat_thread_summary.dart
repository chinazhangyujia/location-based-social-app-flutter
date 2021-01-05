import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/user.dart';

class ChatThreadSummary {
  final User chatWith;
  final String lastMessage;
  final String threadId;
  final DateTime lastMessageSentAt;

  const ChatThreadSummary({
    @required this.chatWith,
    @required this.lastMessage,
    @required this.threadId,
    @required this.lastMessageSentAt
  });
}