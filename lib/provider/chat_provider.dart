import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/chat_message.dart';
import 'package:location_based_social_app/model/chat_thread_summary.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

/// Provider for realtime chat data and service call
class ChatProvider with ChangeNotifier {

  /// The list of chat threads in the chat screen.
  List<ChatThreadSummary> _chatThreadSummaries = [];

  /// The thread that user currently clicked in
  String _openingThread;
  /// messages in the current thread
  List<ChatMessage> _messagesForOpeningThread = [];

  IOWebSocketChannel _channel;

  /// User authentication token
  String _token;

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  void update(String token) {
    _token = token;
  }

  List<ChatThreadSummary> get chatThreadSummaries {
    return _chatThreadSummaries;
  }

  String get openingThread {
    return _openingThread;
  }

  List<ChatMessage> get messagesForOpeningThread {
    return _messagesForOpeningThread;
  }

  Future<void> getAllThreadSummaries() async {
    try {
      final String url = '$SERVICE_DOMAIN/chatThreadSummaries';

      final res = await http.get(
        Uri.parse(url),
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        return;
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<ChatThreadSummary> chatThreadSummaries = responseData.map((e) {
        return _convertResponseToThreadSummary(e as Map<String, dynamic>);
      }).toList();

      _chatThreadSummaries = chatThreadSummaries;
      notifyListeners();
    }
    catch (e) {}
  }

  /// create web socket with server and listen to it
  /// update message list when hearing from web socket
  Future<void> connectToThread(User sendTo) async {

     _channel = IOWebSocketChannel.connect(
        '$WEBSOCKET_DOMAIN/chat?chatWith=${sendTo.id}',
        headers: {
          'Authorization': 'Bearer $_token'
        }
     );

     _channel.stream.listen((event) {
       final responseData = json.decode(event as String) as Map<String, dynamic>;

       final String type = responseData['type'] as String;
       if (type == 'thread') {
         _openingThread = responseData['thread']['_id'] as String;
       } else if (type == 'message') {

         final ChatMessage newMessage = _convertResponseToChatMessage(responseData);
         _appendComingMessage(_openingThread, newMessage);
         notifyListeners();
       }

     }, onError: (error) {
       _openingThread = null;
     }, onDone: () {
       _openingThread = null;
     });

     int waitForThreadMS = 3000;
     while (_openingThread == null && waitForThreadMS > 0) {
       await Future.delayed(const Duration(milliseconds: 10));
       waitForThreadMS -= 10;
     }

     if (_openingThread == null) {
       print('socket connect timeout');
       return;
     }
     else {
       print('takes ${3000 - waitForThreadMS} ms to connect websocket');
     }
  }

  Future<void> sendMessage(User sendFrom, User sendTo, String content) async {

    if (content.isEmpty) {
      return;
    }

    if (_channel == null || _openingThread == null) {
      await _reconnectWebsocket(sendTo);

      if (_channel == null || _openingThread == null) {
        return;
      }
    }

    _channel.sink.add(json.encode({
      'event': 'message',
      'thread': _openingThread,
      'sendFrom': sendFrom.id,
      'sendTo': sendTo.id,
      'content': content
    }));
  }

  Future<void> closeSockets() async {

    if (_openingThread == null) {
      return;
    }

    _channel.sink.add(json.encode({
      'event': 'leave',
      'thread': _openingThread
    }));
    _channel.sink.close();

    _channel = null;
    _openingThread = null;
    _messagesForOpeningThread = [];
  }

  /// called when user click in any thread
  Future<void> getMessagesForThread({User chatWith, int fetchSize = 10, bool refresh = false}) async {

    if (_channel == null || _openingThread == null) {
      await _reconnectWebsocket(chatWith);

      if (_channel == null || _openingThread == null) {
        return;
      }
    }

    try {
      String url = '$SERVICE_DOMAIN/chatMessage?thread=$_openingThread&fetchSize=$fetchSize';

      if (_messagesForOpeningThread.isNotEmpty && !refresh) {
        url += '&fromId=${_messagesForOpeningThread.last.id}';
      }

      final res = await http.get(
        Uri.parse(url),
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        return;
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<ChatMessage> fetchedChatMessages = responseData.map((e) {
        return _convertResponseToChatMessage(e as Map<String, dynamic>);
      }).toList();

      if (refresh) {
        _messagesForOpeningThread = fetchedChatMessages;
      } else {
        _messagesForOpeningThread.addAll(fetchedChatMessages);
      }

      notifyListeners();
    }
    catch (e) {}
  }

  void _appendComingMessage(String thread, ChatMessage newMessage) {
    _messagesForOpeningThread.insert(0, newMessage);

    final ChatThreadSummary effectedSummary = _chatThreadSummaries.firstWhere((element) => element.threadId == thread, orElse: () => null);
    if (effectedSummary == null) {
      return;
    }

    effectedSummary.lastMessage = newMessage.content;
    effectedSummary.lastMessageSentAt = newMessage.sendTime;
  }

  ChatThreadSummary _convertResponseToThreadSummary(Map<String, dynamic> responseData) {
    final Map<String, dynamic> chatWithData = responseData['chatWith'] as Map<String, dynamic>;
    final User chatWith = User(
        id: chatWithData['_id'] as String,
        name: chatWithData['name'] as String,
        avatarUrl: chatWithData['avatarUrl'] as String,
        birthday: DateTime.parse(chatWithData['birthday'] as String),
        introduction: chatWithData['introduction'] as String);

    return ChatThreadSummary(
      chatWith: chatWith,
      lastMessage: responseData['lastMessage'] as String,
      lastMessageSentAt: DateTime.parse(responseData['createdAt'] as String),
      threadId: responseData['_id'] as String
    );
  }

  ChatMessage _convertResponseToChatMessage(Map<String, dynamic> responseData) {
    final Map<String, dynamic> sendToData = responseData['sendTo'] as Map<String, dynamic>;
    final User sendTo = User(
        id: sendToData['_id'] as String,
        name: sendToData['name'] as String,
        avatarUrl: sendToData['avatarUrl'] as String,
        birthday: DateTime.parse(sendToData['birthday'] as String),
        introduction: sendToData['introduction'] as String);

    final Map<String, dynamic> sendFromData = responseData['sendFrom'] as Map<String, dynamic>;
    final User sendFrom = User(
        id: sendFromData['_id'] as String,
        name: sendFromData['name'] as String,
        avatarUrl: sendFromData['avatarUrl'] as String,
        birthday: DateTime.parse(sendFromData['birthday'] as String),
        introduction: sendFromData['introduction'] as String);

    return ChatMessage(
        id: responseData['_id'] as String,
        threadId: responseData['chatThread'] as String,
        sendFrom: sendFrom,
        sendTo: sendTo,
        content: responseData['content'] as String,
        sendTime: DateTime.parse(responseData['createdAt'] as String)
    );
  }

  Future<void> _reconnectWebsocket(User chatWith) async {
    if (_channel == null || _openingThread == null) {
      print("haven't connect to websocket");
      await connectToThread(chatWith);
    }
    else {
      return;
    }

    int waitForThreadMS = 3000;
    while (_openingThread == null && waitForThreadMS > 0) {
      await Future.delayed(const Duration(milliseconds: 10));
      waitForThreadMS -= 10;
    }

    if (_openingThread == null) {
      print('socket connect timeout');
      return;
    }
    else {
      print('takes ${3000 - waitForThreadMS} ms to connect websocket');
    }
  }
}