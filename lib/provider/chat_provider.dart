import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:location_based_social_app/model/chat_message.dart';
import 'package:location_based_social_app/model/chat_thread_summary.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/util/config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class ChatProvider with ChangeNotifier {

  List<ChatThreadSummary> _chatThreadSummaries = [];

  String _openingThread;
  List<ChatMessage> _messagesForOpeningThread = [];

  IOWebSocketChannel _channel;

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
      String url = '${SERVICE_DOMAIN}/chatThreadSummaries';

      final res = await http.get(
        url,
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        return;
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      List<ChatThreadSummary> chatThreadSummaries = responseData.map((e) {
        return _convertResponseToThreadSummary(e);
      }).toList();

      _chatThreadSummaries = chatThreadSummaries;
      notifyListeners();
    }
    catch (e) {

    }
  }

  Future<void> connectToThread(User sendTo) async {

     _channel = IOWebSocketChannel.connect(
        '${WEBSOCKET_DOMAIN}/chat?chatWith=${sendTo.id}',
        headers: {
          'Authorization': 'Bearer $_token'
        }
     );

     _channel.stream.listen((event) {
       final responseData = json.decode(event) as Map<String, dynamic>;

       String type = responseData['type'];
       if (type == 'thread') {
         _openingThread = responseData['thread']['_id'];
       } else if (type == 'message') {

         ChatMessage newMessage = _convertResponseToChatMessage(responseData);
         _appendComingMessage(_openingThread, newMessage);
         notifyListeners();
       }

     }, onError: (error) {
       print('error happens');
       _openingThread = null;
     }, onDone: () {
       print('connection done');
       _openingThread = null;
     });

     int waitForThreadMS = 3000;
     while (_openingThread == null && waitForThreadMS > 0) {
       await Future.delayed(Duration(milliseconds: 10));
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

  Future<void> getMessagesForThread({User chatWith, int fetchSize = 10, bool refresh = false}) async {

    if (_channel == null || _openingThread == null) {
      await _reconnectWebsocket(chatWith);

      if (_channel == null || _openingThread == null) {
        return;
      }
    }

    try {
      String url = '${SERVICE_DOMAIN}/chatMessage?thread=$_openingThread&fetchSize=$fetchSize';

      if (_messagesForOpeningThread.isNotEmpty && !refresh) {
        url += '&fromId=${_messagesForOpeningThread.last.id}';
      }

      final res = await http.get(
        url,
        headers: {...requestHeader, 'Authorization': 'Bearer $_token'},
      );

      if (res.statusCode != 200) {
        return;
      }

      final responseData = json.decode(res.body) as List<dynamic>;

      final List<ChatMessage> fetchedChatMessages = responseData.map((e) {
        return _convertResponseToChatMessage(e);
      }).toList();

      if (refresh) {
        _messagesForOpeningThread = fetchedChatMessages;
      } else {
        _messagesForOpeningThread.addAll(fetchedChatMessages);
      }

      notifyListeners();
    }
    catch (e) {
      print(e);
    }
  }

  void _appendComingMessage(String thread, ChatMessage newMessage) {
    _messagesForOpeningThread.insert(0, newMessage);

    ChatThreadSummary effectedSummary = _chatThreadSummaries.firstWhere((element) => element.threadId == thread, orElse: () => null);
    if (effectedSummary == null) {
      return;
    }

    effectedSummary.lastMessage = newMessage.content;
    effectedSummary.lastMessageSentAt = newMessage.sendTime;
  }

  ChatThreadSummary _convertResponseToThreadSummary(Map<String, dynamic> responseData) {
    Map<String, dynamic> chatWithData = responseData['chatWith'];
    User chatWith = User(
        id: chatWithData['_id'],
        name: chatWithData['name'],
        avatarUrl: chatWithData['avatarUrl'],
        birthday: DateTime.parse(chatWithData['birthday']),
        introduction: chatWithData['introduction']);

    return ChatThreadSummary(
      chatWith: chatWith,
      lastMessage: responseData['lastMessage'],
      lastMessageSentAt: DateTime.parse(responseData['createdAt']),
      threadId: responseData['_id']
    );
  }

  ChatMessage _convertResponseToChatMessage(Map<String, dynamic> responseData) {
    Map<String, dynamic> sendToData = responseData['sendTo'];
    User sendTo = User(
        id: sendToData['_id'],
        name: sendToData['name'],
        avatarUrl: sendToData['avatarUrl'],
        birthday: DateTime.parse(sendToData['birthday']),
        introduction: sendToData['introduction']);

    Map<String, dynamic> sendFromData = responseData['sendFrom'];
    User sendFrom = User(
        id: sendFromData['_id'],
        name: sendFromData['name'],
        avatarUrl: sendFromData['avatarUrl'],
        birthday: DateTime.parse(sendFromData['birthday']),
        introduction: sendFromData['introduction']);

    return ChatMessage(
        id: responseData['_id'],
        threadId: responseData['chatThread'],
        sendFrom: sendFrom,
        sendTo: sendTo,
        content: responseData['content'],
        sendTime: DateTime.parse(responseData['createdAt'])
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
      await Future.delayed(Duration(milliseconds: 10));
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